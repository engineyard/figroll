require 'figroll/config'
require 'figroll/storage'

module Figroll
  def self.load_file(config_file)
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

  def self.fetch(key)
    storage.fetch(key)
  end

  def self.storage
    @storage
  end

  def self.config
    @config
  end

  
  def self.validate_configuration
    return nil if required.length == 0
    return nil if (keys - required).length == keys.length - required.length

    missing = required.reject {|key| keys.include?(key)}
    raise "Required variables not set: #{missing}"
  end

  def self.required
    config.required
  end

  def self.keys
    storage.keys
  end

  def self.environment
    config.environment
  end

  def self.normalize(key)
    key.to_s.upcase.gsub(/\s+/, '_')
  end

  def self.setup
    @config = Config.new
    @storage = Storage.new
  end
end
