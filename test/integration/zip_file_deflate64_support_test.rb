# frozen_string_literal: true

require 'test_helper'

class ZipFileDeflate64SupportTest < Minitest::Test
  DEFLATE64_ZIP_FILE = 'test/data/zipWithDeflate64Compression.zip'
  FILE1 = 'test/data/file1.txt'
  FILE2 = 'test/data/file2.txt'

  def test_file_read
    Zip::File.open(DEFLATE64_ZIP_FILE) do |zipfile|
      assert_equal file1_text, zipfile.read('file1.txt')
      assert_equal file2_text, zipfile.read('file2.txt')
    end
  end

  private

  def file1_text
    @file1_text ||= File.read(FILE1)
  end

  def file2_text
    @file2_text ||= File.read(FILE2)
  end
end
