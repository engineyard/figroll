module Figroll
  class Storage
    attr_reader :vars

    def initialize
      reset
    end

    def fetch(key)
      @vars.fetch(Figroll.normalize(key))
    end

    def import(incoming)
      incoming.keys.each do |key|
        vars[Figroll.normalize(key)] = incoming[key]
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
