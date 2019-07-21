module Figroll
  module Util

    def self.normalize(key)
      key.to_s.upcase.gsub(/\s+/, '_')
    end

  end
end
