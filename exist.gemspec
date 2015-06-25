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

  gem.add_dependency 'faraday', '~> 0.9'
  gem.add_dependency 'faraday_middleware', '~> 0.9'
  gem.add_dependency 'hashie', '~> 3.4'
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'webmock', '>= 1.21.0'
  gem.add_development_dependency 'simplecov', '>= 0.10.0'
  gem.add_development_dependency 'coveralls', '>= 0.8.2'
  gem.add_development_dependency 'rubocop', '>= 0.32.1 '
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'pry'
end
