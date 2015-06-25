# -*- encoding: utf-8 -*-

require File.expand_path('../lib/exist/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "exist"
  gem.version       = Exist::VERSION
  gem.summary       = "Ruby client for the Exist.IO API"
  gem.description   = gem.summary
  gem.license       = "MIT"
  gem.authors       = ["Adrian Perez"]
  gem.email         = "adrianperez.deb@gmail.com"
  gem.homepage      = "https://github.com/blackxored/exist"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'hashie'
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'pry'
end
