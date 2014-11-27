# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hash_path/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Daniel Neighman"]
  gem.email         = ["dneighman@squareup.com"]
  gem.description   = %q{Easy path navigation for hashes}
  gem.summary       = %q{Easy path navigation for hashes. Useful in specs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hash_path"
  gem.require_paths = ["lib"]
  gem.version       = HashPath::VERSION
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'pry'
end
