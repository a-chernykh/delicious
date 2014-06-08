lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delicious/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'multi_xml'
  spec.add_dependency 'activemodel'

  spec.add_development_dependency 'bundler', '~> 1.0'

  spec.authors = ['Andrey Chernih']
  spec.description = 'Ruby wrapper for delicious.com API'
  spec.email = %w(andrey.chernih@gmail.com)
  spec.files = %w(delicious.gemspec)
  spec.files += Dir.glob('lib/**/*.rb')
  spec.files += Dir.glob('spec/**/*')
  spec.homepage = 'http://github.com/andreychernih/delicious'
  spec.licenses = ['Apache 2.0']
  spec.name = 'delicious'
  spec.require_paths = %w(lib)
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = spec.description
  spec.test_files = Dir.glob('spec/**/*')
  spec.version = Delicious.version
end
