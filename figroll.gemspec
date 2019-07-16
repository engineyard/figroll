# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'figroll/version'

Gem::Specification.new do |gem|
  gem.name    = "figroll"
  gem.version = Figroll::VERSION

  gem.author      = "EY Cloud Team"
  gem.email       = "cloud@engineyard.com"
  gem.summary     = "Rails 2 configuration via ENV"
  gem.description = "Rails 2 app configuration using ENV and a single YAML file"
  gem.homepage    = "https://github.com/engineyard/figroll"
  gem.license     = "MIT"

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.4"
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'simplecov'

  gem.files      = `git ls-files`.split($\)
  gem.files.reject! {|file| ['Dockerfile', 'docker-compose.yml'].include?(file)}
  gem.test_files = gem.files.grep(/^(spec|mock)/)

end
