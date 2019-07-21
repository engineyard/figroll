require 'figroll/util'

module Figroll
  class Storage
    attr_reader :vars

    def initialize
      reset
    end

    def fetch(key)
      @vars.fetch(Util.normalize(key))
    end

    def import(incoming)
      incoming.keys.each do |key|
        vars[Util.normalize(key)] = incoming[key]
      end

      nil
    end

    def keys
      vars.keys
    end

    private
    def reset
      @vars = {}
    end
  end
end
