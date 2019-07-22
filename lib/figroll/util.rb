module Figroll

  # A collection of utility methods used throughout Figroll
  module Util

    # Normalize a given key to the format generally used for environment
    # variable names.
    # @param key [String, Symbol] the key to normalize
    # @return [String] the normalized key
    def self.normalize(key)
      key.to_s.upcase.gsub(/\s+/, '_')
    end

  end
end
