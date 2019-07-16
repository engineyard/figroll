require 'yaml'

module Figroll
  class Config
    attr_reader :required, :environment, :data

    def initialize
      reset
    end

    def load_file(config_file)
      return unless File.exists?(config_file)

      file_data = YAML.load_file(config_file) || {}

      # set up required keys
      file_data['required'] ||= []
      file_data['required'].each do |key|
        required.push(Figroll.normalize(key))
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
