module Figroll
  @vars = {}

  def self.load(config_file)
    # load config file
    # load required ENV values
    # verify all required variables are set
  end

  def self.fetch(key)
    @vars.fetch(key.to_s.downcase.to_sym)
  end


end
