# frozen_string_literal: true

require 'test_helper'

class DecompressTest < Minitest::Test
  FILE = 'test/data/file1.txt'
  DEFLATE64_FILE = 'test/data/file1.txt.deflate64'

  def setup
    @decompress = Zip::Deflate64::Decompress.new
  end

  def test_decompress
    assert_equal(file_text, @decompress.decompress(compressed_data))
    assert_predicate(@decompress, :finished?)
  end

  def test_decompress_partial_start
    assert_equal(file_text[0..757], @decompress.decompress(compressed_data[0..300]))
    refute_predicate(@decompress, :finished?)
  end

  def test_decompress_partial_finish
    @decompress.decompress(compressed_data[0..300])

    assert_equal(file_text[758..], @decompress.decompress(compressed_data[301..600]))
    assert_predicate(@decompress, :finished?)
  end

  def test_decompress_with_corrupted_input
    input = compressed_data
    input[40] = 'X'

    assert_raises(Zip::Deflate64::DataError) do
      @decompress.decompress(input)
    end
  end

  private

  def file_text
    @file_text ||= File.read(FILE)
  end

  def compressed_data
    @compressed_data ||= File.binread(DEFLATE64_FILE)
  end
end
