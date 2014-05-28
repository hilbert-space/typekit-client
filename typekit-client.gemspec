lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'typekit/version'

Gem::Specification.new do |spec|
  spec.name          = 'typekit-client'
  spec.version       = Typekit::VERSION
  spec.authors       = [ 'Ivan Ukhov' ]
  spec.email         = [ 'ivan.ukhov@gmail.com' ]
  spec.summary       = 'A Ruby library for accessing the Typekit API'
  spec.description   = 'A Ruby library for performing create, read, ' \
                       'update, and delete operations on the resources ' \
                       'provided by the Typekit service.'
  spec.homepage      = 'https://github.com/IvanUkhov/typekit-client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = [ 'lib' ]

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'rack', '~> 1.5'
  spec.add_dependency 'json', '~> 1.8'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'webmock', '~> 1.18'
  spec.add_development_dependency 'vcr', '~> 2.9'
end
