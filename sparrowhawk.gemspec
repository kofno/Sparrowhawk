lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'sparrowhawk'

Gem::Specification.new do |s|
  s.name = "sparrowhawk"
  s.version = Sparrowhawk::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Ryan L. Bell']
  s.email = ['ryan.l.bell@gmail.com']
  s.homepage = "https://github.com/kofno/Sparrowhawk"
  s.summary = "An MRI friendly war packaginer for rack applications"
  s.description = "Sparrowhawk uses bundler and vendor/cache to package rails applications into a war file, without executing Java or JRuby"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'rubyzip'
  s.add_dependency 'jruby-jars'
  s.add_dependency 'jruby-rack'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'nokogiri'

  s.files = Dir["{lib}/**/*"] + %w(LICENSE README.md CHANGELOG.md)
  s.require_path = 'lib'
end
