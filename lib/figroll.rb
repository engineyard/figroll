require 'figroll/config'
require 'figroll/storage'

# A simple universal ENV-focused configuration library
module Figroll

  # Given a config file, set up Figroll for ENV consumption
  # @param config_file [String] the figroll configuration for your app
  def self.configure(config_file)
    setup

    # Load the config file
    config.load_file(config_file)

    # Import the environment configuration from the config
    storage.import(config.data)

    # Import the actual ENV hash
    storage.import(ENV)

    # verify all required variables are set
    validate_configuration
  end

  # Retrieve the value of an environment configuration variable. The key may be
  # either a String or a Symbol, non-case-sensitive. For example, these all
  # reference the same value: `'i am a variable'`, `'i_am_a_variable'`,
  # `'I_AM_A_VARIABLE'`, `:i_am_a_variable`
  # @param key [String, Symbol] the stringified or symbolized name of the
  #   variable for which you want to know the value.
  def self.fetch(key)
    storage.fetch(key)
  end

  class << self
    private

    def storage
      @storage
    end

    def config
      @config
    end

    def validate_configuration
      return nil if required.length == 0
      return nil if (keys - required).length == keys.length - required.length

      missing = required.reject {|key| keys.include?(key)}
      raise "Required variables not set: #{missing.sort.join(', ')}"
    end

    def required
      config.required
    end

    def keys
      storage.keys
    end

    def environment
      config.environment
    end

    def setup
      @config = Config.new
      @storage = Storage.new
    end
  end
end
