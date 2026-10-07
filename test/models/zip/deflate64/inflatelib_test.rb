# frozen_string_literal: true

require 'test_helper'

class InflatelibTest < Minitest::Test
  FILE = 'test/data/file1.txt'
  DEFLATE64_FILE = 'test/data/file1.txt.deflate64'

  def test_inflatelib_decompression
    output = decompress(compressed_data)

    assert_equal(file_text, output)
  end

  def test_inflatelib_decompression_with_corrupted_input
    input = compressed_data
    input[40] = 'X'

    assert_raises(Zip::Deflate64::DataError) do
      decompress(input)
    end
  end

  def test_invalid_inflatelib_configuration
    Zip::Deflate64::FFI::Inflatelib.stub(
      :inflatelib_init_,
      Zip::Deflate64::FFI::Inflatelib::INFLATELIB_ERROR_VERSION
    ) do
      assert_raises(Zip::Deflate64::ConfigError) do
        decompress(compressed_data)
      end
    end
  end

  def test_inflatelib_decompression_with_inflatelib_memory_error
    Zip::Deflate64::FFI::Inflatelib.stub(
      :inflatelib_inflate64,
      Zip::Deflate64::FFI::Inflatelib::INFLATELIB_ERROR_OOM
    ) do
      assert_raises(Zip::Deflate64::MemError) do
        decompress(compressed_data)
      end
    end
  end

  def test_inflatelib_decompression_with_invalid_arg_error
    Zip::Deflate64::FFI::Inflatelib.stub(
      :inflatelib_inflate64,
      Zip::Deflate64::FFI::Inflatelib::INFLATELIB_ERROR_ARG
    ) do
      assert_raises(Zip::Deflate64::UnexpectedError) do
        decompress(compressed_data)
      end
    end
  end

  def test_inflatelib_decompression_with_unexpected_error
    Zip::Deflate64::FFI::Inflatelib.stub(:inflatelib_inflate64, -999) do
      assert_raises(Zip::Deflate64::UnexpectedError) do
        decompress(compressed_data)
      end
    end
  end

  private

  def decompress(data)
    input_buffer = Zip::Deflate64::Inflatelib.buffer_from_data(data)
    output_buffer = Zip::Deflate64::Inflatelib.buffer(4096)

    inflatelib = Zip::Deflate64::Inflatelib.new
    inflatelib.input_buffer = input_buffer
    inflatelib.output_buffer = output_buffer
    inflatelib.decompress_start
    inflatelib.decompress?
    output = inflatelib.output
    inflatelib.decompress_finish

    output_buffer.free
    input_buffer.free

    output
  end

  def file_text
    @file_text ||= File.read(FILE)
  end

  def compressed_data
    @compressed_data ||= File.binread(DEFLATE64_FILE)
  end
end
