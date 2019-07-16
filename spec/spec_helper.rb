unless RUBY_VERSION =~ /^1\.8\./
  require 'simplecov'
  SimpleCov.coverage_dir 'coverage'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/mock/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
MOCK_PATH = File.expand_path('../../mock', __FILE__)
require 'figroll'
