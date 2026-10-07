# frozen_string_literal: true

require_relative 'errors'
require_relative 'ffi/inflatelib'

module Zip
  module Deflate64
    class Inflatelib # :nodoc:
      def self.finalizer(stream)
        lambda do |_id|
          FFI::Inflatelib.inflatelib_destroy(stream)
        end
      end
      private_class_method :finalizer

      def self.buffer(length)
        ::FFI::MemoryPointer.new(1, length)
      end

      def self.buffer_from_data(data)
        buffer = ::FFI::MemoryPointer.new(1, data.bytesize)
        buffer.write_bytes(data)
        buffer
      end

      def initialize
        @stream = FFI::Inflatelib::InflatelibStream.new
      end

      def decompress_start
        result = FFI::Inflatelib.inflatelib_init(@stream)
        check_error(result)

        ObjectSpace.define_finalizer(self, self.class.send(:finalizer, @stream))
      end

      def decompress?
        result = FFI::Inflatelib.inflatelib_inflate64(@stream)
        check_error(result)

        result == FFI::Inflatelib::INFLATELIB_EOF
      end

      def decompress_finish
        result = FFI::Inflatelib.inflatelib_destroy(@stream)
        check_error(result)

        ObjectSpace.undefine_finalizer(self)
      end

      def input_buffer=(input_buffer)
        @stream[:next_in] = input_buffer
        @stream[:avail_in] = input_buffer.size
      end

      def output_buffer=(output_buffer)
        @output_buffer = output_buffer
        @stream[:next_out] = output_buffer
        @stream[:avail_out] = output_buffer.size
      end

      def input?
        @stream[:avail_in].positive?
      end

      def output
        @output_buffer.read_bytes(@output_buffer.size - @stream[:avail_out])
      end

      private

      def check_error(result)
        return unless result < FFI::Inflatelib::INFLATELIB_OK

        raise error(result)
      end

      def error(result)
        case result
        when FFI::Inflatelib::INFLATELIB_ERROR_ARG
          UnexpectedError.new('Inflatelib received an invalid argument.')
        when FFI::Inflatelib::INFLATELIB_ERROR_DATA
          DataError.new("Inflatelib detected an error in the input data: #{@stream[:error_msg]}")
        when FFI::Inflatelib::INFLATELIB_ERROR_OOM
          MemError.new('Inflatelib failed to allocate memory.')
        when FFI::Inflatelib::INFLATELIB_ERROR_VERSION
          ConfigError.new('Inflatelib version mismatch.')
        else
          UnexpectedError.new("Inflatelib reported an unexpected error (error code: #{result})")
        end
      end
    end
  end
end
