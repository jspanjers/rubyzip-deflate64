# frozen_string_literal: true

require_relative 'decompress'

module Zip # :nodoc:
  module Deflate64
    class Decompressor < ::Zip::Decompressor # :nodoc:
      def initialize(*args)
        super

        @buffer = +''
        @deflate64_ffi_decompressor = ::Zip::Deflate64::Decompress.new
      end

      def read(length = nil, outbuf = +'')
        return return_value_on_eof(length) if eof

        fill_buffer(length)

        outbuf.replace(@buffer.slice!(0...(length || @buffer.bytesize)))
      end

      def eof?
        @buffer.empty? && input_finished?
      end

      alias eof eof?

      def return_value_on_eof(length)
        '' if length.nil? || length.zero?
      end

      def fill_buffer(min_length)
        while min_length.nil? || (@buffer.bytesize < min_length)
          break if input_finished?

          @buffer << produce_input
        end
      end

      def produce_input
        @deflate64_ffi_decompressor.decompress(input_stream.read(Decompressor::CHUNK_SIZE))
      rescue Deflate64::Error => e
        raise(::Zip::DecompressionError, e)
      end

      def input_finished?
        @deflate64_ffi_decompressor.finished?
      end
    end
  end

  ::Zip::Decompressor.register(::Zip::COMPRESSION_METHOD_DEFLATE_64, ::Zip::Deflate64::Decompressor)
end
