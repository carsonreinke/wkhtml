# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wkhtml/version'

Gem::Specification.new do |gem|
  gem.name          = "wkhtml"
  gem.version       = WkHtml::VERSION
  gem.authors       = ["carsonreinke"]
  gem.email         = ["carson@reinke.co"]
  gem.description   = %q{Ruby bindings for wkhtmltopdf and wkhtmltoimage}
  gem.summary       = %q{Ruby bindings for wkhtmltox}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.extensions << 'ext/wkhtml/extconf.rb'
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rake-compiler'
  gem.add_development_dependency 'rspec'
end
