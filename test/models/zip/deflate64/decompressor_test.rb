# frozen_string_literal: true

require 'test_helper'

class DecompressorTest < Minitest::Test
  FILE1 = 'test/data/file1.txt'
  DEFLATE64_FILE = 'test/data/file1.txt.deflate64'
  DEFLATE64_FILE_CORRUPT = 'test/data/file1.txt.corrupt.deflate64'

  def test_read_everything
    File.open(DEFLATE64_FILE, 'rb') do |file|
      decompressor = ::Zip::Deflate64::Decompressor.new(file)

      assert_equal(test_text, decompressor.read)
    end
  end

  def test_read_in_chunks
    File.open(DEFLATE64_FILE, 'rb') do |file|
      decompressor = ::Zip::Deflate64::Decompressor.new(file)
      chunk_size = 5

      while (decompressed_chunk = decompressor.read(chunk_size))
        assert_equal(test_text.slice!(0, chunk_size), decompressed_chunk)
      end

      assert_equal(0, test_text.size)
    end
  end

  def test_data_error
    File.open(DEFLATE64_FILE_CORRUPT, 'rb') do |file|
      decompressor = ::Zip::Deflate64::Decompressor.new(file)

      assert_raises(::Zip::DecompressionError) do
        decompressor.read
      end
    end
  end

  private

  def test_text
    @test_text ||= File.read(FILE1)
  end
end
