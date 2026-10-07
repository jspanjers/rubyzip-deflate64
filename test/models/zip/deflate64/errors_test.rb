# frozen_string_literal: true

require 'test_helper'

class ErrorsTest < Minitest::Test
  def test_deflate64_error
    assert_raises(Zip::Deflate64::Error) do
      raise ::Zip::Deflate64::Error, 'foo'
    end
  end

  def test_deflate64_data_error
    assert_raises(Zip::Deflate64::Error) do
      raise ::Zip::Deflate64::DataError, 'foo'
    end
  end

  def test_deflate64_mem_error
    assert_raises(Zip::Deflate64::Error) do
      raise ::Zip::Deflate64::MemError, 'foo'
    end
  end

  def test_deflate64_config_error
    assert_raises(Zip::Deflate64::Error) do
      raise ::Zip::Deflate64::ConfigError, 'foo'
    end
  end

  def test_deflate64_unexpected_error
    assert_raises(Zip::Deflate64::Error) do
      raise ::Zip::Deflate64::UnexpectedError, 'foo'
    end
  end
end
