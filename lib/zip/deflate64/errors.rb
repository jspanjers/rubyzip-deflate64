# frozen_string_literal: true

module Zip
  module Deflate64
    # Base class for Zip::Deflate64 exceptions.
    class Error < IOError
    end

    # Raised for invalid arguments.
    class ArgError < Error
      # Initializes a new instance of DataError.
      #
      # @param message [String] Exception message (overrides the default).
      # @private
      def initialize(message = nil) # :nodoc:
        super(message || 'Invalid argument')
      end
    end

    # Raised for data errors (e.g. a data integrity error is detected).
    class DataError < Error
      # Initializes a new instance of DataError.
      #
      # @param message [String] Exception message (overrides the default).
      # @private
      def initialize(message = nil) # :nodoc:
        super(message || 'Data error')
      end
    end

    # Raised for memory errors (e.g. a failure to allocate memory).
    class MemError < Error
      # Initializes a new instance of MemError.
      #
      # @param message [String] Exception message (overrides the default).
      # @private
      def initialize(message = nil) # :nodoc:
        super(message || 'Memory error')
      end
    end

    # Raised for configuration errors (e.g. library mismatch).
    class ConfigError < Error
      # Initializes a new instance of ConfigError.
      #
      # @param message [String] Exception message (overrides the default).
      # @private
      def initialize(message = nil) # :nodoc:
        super(message || 'Configuration error')
      end
    end

    # Raised for unexpected errors.
    class UnexpectedError < Error
      # Initializes a new instance of UnexpectedError.
      #
      # @param message [String] Exception message (overrides the default).
      # @private
      def initialize(message = nil) # :nodoc:
        super(message || 'Unknown error')
      end
    end
  end
end
