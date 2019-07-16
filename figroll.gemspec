# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name    = "figroll"
  gem.version = "0.0.1"

  gem.author      = "EY Cloud Team"
  gem.email       = "cloud@engineyard.com"
  gem.summary     = "Rails 2 configuration via ENV"
  gem.description = "Rails 2 app configuration using ENV and a single YAML file"
  gem.homepage    = "https://github.com/engineyard/figroll"
  gem.license     = "MIT"

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.4"
  gem.add_development_dependency 'rspec', '~> 2.14'

  gem.files      = `git ls-files`.split($\)
  gem.test_files = gem.files.grep(/^spec/)

end
