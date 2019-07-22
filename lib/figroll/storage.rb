require 'figroll/util'

module Figroll
  # A storage object for Figroll
  class Storage
    # The known variables tracked by this storage instance
    # @return [Hash<String, String>]
    # @api private
    attr_reader :vars

    # Create a new Storage instance
    # @api private
    def initialize
      reset
    end

    # Given a key, retrieve the value stored for that key.
    # @param key [String, Symbol] the variable for which we want a value
    # @return [String] the value of that variable
    # @raise [RuntimeError] if the varible is not known
    # @api private
    def fetch(key)
      @vars.fetch(Util.normalize(key))
    end

    # Given a hash of variables, import those variables into the instance.
    # @params incoming [Hash<String, String>]
    # @return nil
    # @api private
    def import(incoming)
      incoming.keys.each do |key|
        vars[Util.normalize(key)] = incoming[key]
      end

      nil
    end

    # Get the list of all stored variable names
    # @return [Array<String>]
    # @api private
    def keys
      vars.keys
    end

    private
    def reset
      @vars = {}
    end
  end
end
