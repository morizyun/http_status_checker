# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_status_checker/version'

Gem::Specification.new do |spec|
  spec.name          = 'http_status_checker'
  spec.version       = HttpStatusChecker::VERSION
  spec.authors       = ['morizyun']
  spec.email         = ['merii.ken@gmail.com']
  spec.summary       = %q{Easily Checking http status by http header with Multi-threaded}
  spec.description   = %q{Easily Checking http status by http header with Multi-threaded}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'
  spec.add_dependency 'thor'
  spec.add_dependency 'parallel'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'fakeweb'
  spec.add_development_dependency 'rspec'
end
