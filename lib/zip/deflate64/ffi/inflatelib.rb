# frozen_string_literal: true

require 'ffi'

module Zip
  module Deflate64
    module FFI
      # FFI bindings for the inflatelib low-level interface.
      #
      # See inflatelib.h and https://github.com/microsoft/inflatelib.
      #
      # @private
      module Inflatelib # :nodoc:
        extend ::FFI::Library

        ffi_lib ['inflatelib', 'libinflatelib.so.0', 'inflatelib.dll']

        INFLATELIB_OK = 0
        INFLATELIB_EOF = 1
        INFLATELIB_ERROR_ARG = -1
        INFLATELIB_ERROR_DATA = -2
        INFLATELIB_ERROR_OOM = -3
        INFLATELIB_ERROR_VERSION = -4

        # typedef void* (*inflatelib_alloc)(void* userData, size_t bytes, size_t alignment);
        callback :inflatelib_alloc, %i[pointer size_t size_t], :pointer

        # typedef void (*inflatelib_free)(void* userData, void* allocatedPtr, size_t bytes, size_t alignment);
        callback :inflatelib_free, %i[pointer pointer size_t size_t], :void

        # typedef struct inflatelib_stream;
        class InflatelibStream < ::FFI::Struct # :nodoc:
          layout(
            :next_in, :pointer,
            :avail_in, :size_t,
            :total_in, :uintmax_t,
            :next_out, :pointer,
            :avail_out, :size_t,
            :total_out, :uintmax_t,
            :user_data, :pointer,
            :alloc, :inflatelib_alloc,
            :free, :inflatelib_free,
            :error_msg, :string,
            :internal, :pointer
          )
        end

        INFLATELIB_COMPATIBLE_VERSION_STRING = '0.x.x'
        private_constant :INFLATELIB_COMPATIBLE_VERSION_STRING

        def self.inflatelib_init(inflatelib_stream)
          inflatelib_init_(inflatelib_stream, INFLATELIB_COMPATIBLE_VERSION_STRING)
        end

        # int inflatelib_init_(inflatelib_stream* stream, const char* version);
        attach_function :inflatelib_init_, [InflatelibStream.by_ref, :string], :int

        # int inflatelib_reset(inflatelib_stream* stream);
        attach_function :inflatelib_reset, [InflatelibStream.by_ref], :int

        # int inflatelib_destroy(inflatelib_stream* stream);
        attach_function :inflatelib_destroy, [InflatelibStream.by_ref], :int

        # int inflatelib_inflate(inflatelib_stream* stream);
        attach_function :inflatelib_inflate, [InflatelibStream.by_ref], :int

        # int inflatelib_inflate64(inflatelib_stream* stream);
        attach_function :inflatelib_inflate64, [InflatelibStream.by_ref], :int
      end
    end
  end
end
