# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'net/ntp/check/version'

Gem::Specification.new do |spec|
  spec.name          = 'net-ntp-check'
  spec.version       = Net::NTP::Check::VERSION
  spec.authors       = ['Grant Ridder']
  spec.email         = ['shortdudey123@gmail.com']
  spec.summary       = 'NTP offset check'
  spec.description   = 'Checks NTP offset against several NTP servers and allows pushing of offset stats via statsd'
  spec.license       = 'MIT'
  spec.homepage      = ''

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'net-ntp'
  spec.add_dependency 'statsd-ruby'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'coveralls'
end
