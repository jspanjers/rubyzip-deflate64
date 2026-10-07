# frozen_string_literal: true

require_relative 'inflatelib'

module Zip
  module Deflate64
    class Decompress # :nodoc:
      OUTPUT_BUFFER_SIZE = 4096

      def initialize
        @inflatelib = Inflatelib.new.tap(&:decompress_start)
        @finished = false
      end

      def decompress(data)
        result = +''

        with_input_buffer(data) do |input_buffer|
          @inflatelib.input_buffer = input_buffer

          with_output_buffer(OUTPUT_BUFFER_SIZE) do |output_buffer|
            while @inflatelib.input?
              @inflatelib.output_buffer = output_buffer

              @finished = @inflatelib.decompress?
              result += @inflatelib.output
              next unless @finished

              @inflatelib.decompress_finish
              break
            end
          end
        end

        result
      end

      def finished?
        @finished
      end

      private

      def with_input_buffer(data)
        input_buffer = nil
        begin
          input_buffer = Inflatelib.buffer_from_data(data)
          yield input_buffer
        ensure
          input_buffer&.free
        end
      end

      def with_output_buffer(length)
        output_buffer = nil
        begin
          output_buffer = Inflatelib.buffer(length)
          yield output_buffer
        ensure
          output_buffer&.free
        end
      end
    end
  end
end
