lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'typekit/version'

Gem::Specification.new do |spec|
  spec.name          = 'typekit-client'
  spec.version       = Typekit::VERSION
  spec.authors       = [ 'Ivan Ukhov' ]
  spec.email         = [ 'ivan.ukhov@gmail.com' ]
  spec.summary       = 'A Ruby library for accessing the Typekit API'
  spec.description   = 'A Ruby library for manipulating the resources ' \
                       'provided by the Typekit Web service.'
  spec.homepage      = 'https://github.com/IvanUkhov/typekit-client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = [ 'lib' ]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'rack', '~> 1.5'
  spec.add_dependency 'json', '~> 1.8'
  spec.add_dependency 'apitizer', '~> 0.0.3'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-bdd', '~> 0.0.2'
  spec.add_development_dependency 'webmock', '~> 1.18'
  spec.add_development_dependency 'vcr', '~> 2.9'

  spec.add_development_dependency 'redcarpet', '~> 3.1'
  spec.add_development_dependency 'yard', '~> 0.8'

  spec.add_development_dependency 'guard', '~> 2.6'
  spec.add_development_dependency 'guard-rspec', '~> 4.2'
end
