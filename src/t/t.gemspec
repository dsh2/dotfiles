# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 't/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'launchy', '~> 2.4'
  spec.add_dependency 'geokit', '~> 1.9'
  spec.add_dependency 'htmlentities', '~> 4.3'
  spec.add_dependency 'oauth', '~> 0.5.1'
  spec.add_dependency 'retryable', '~> 2.0'
  spec.add_dependency 'thor', ['>= 0.19.1', '< 2']
  spec.add_dependency 'twitter', '~> 6.0'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.author = 'Erik Michaels-Ober'
  spec.description = 'A command-line power tool for Twitter.'
  spec.email = 'sferik@gmail.com'
  spec.executables = Dir['bin/*'].map { |f| File.basename(f) }
  spec.files = %w(CONTRIBUTING.md LICENSE.md README.md t.gemspec) + Dir['bin/*'] + Dir['lib/**/*.rb']
  spec.homepage = 'http://sferik.github.com/t/'
  spec.licenses = %w(MIT)
  spec.name = 't'
  spec.require_paths = %w(lib)
  spec.required_ruby_version = '>= 2'
  spec.summary = 'CLI for Twitter'
  spec.version = T::Version
end
