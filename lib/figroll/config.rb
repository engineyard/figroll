require 'yaml'
require 'figroll/util'

module Figroll
  # A configuration object for Figroll
  class Config

    # A list of required environment variables defined by the configuration
    # @return [Array<String>, nil]
    # @api private
    attr_reader :required

    # The `FIGROLL_ENV` under which we're running
    # @return [String, nil]
    # @api private
    attr_reader :environment

    # Values defined in the configuration to inject into Figroll
    # @return [Array<String>, nil]
    # @api private
    attr_reader :data

    # Create a new Config instance
    # @api private
    def initialize
      reset
    end

    # Given a config file name, load the configuration specified in that file.
    # @param config_file [String]
    # @api private
    def load_file(config_file)
      return unless File.exists?(config_file)

      file_data = YAML.load_file(config_file) || {}

      # set up required keys
      file_data['required'] ||= []
      file_data['required'].each do |key|
        required.push(Util.normalize(key))
      end

      # load up the environment-specific data
      file_data['environments'] ||= {}
      @data = file_data['environments'][environment] || {}
    end

    private
    def reset
      @environment = ENV['FIGROLL_ENV']
      @required = []
      @data = {}
    end
  end
end
