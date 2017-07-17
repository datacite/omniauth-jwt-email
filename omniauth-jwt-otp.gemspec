require "date"
require File.expand_path("../lib/omniauth/jwt_otp/version", __FILE__)

Gem::Specification.new do |s|
  s.authors       = "Martin Fenner"
  s.email         = "mfenner@datacite.org"
  s.name          = "omniauth-jwt-otp"
  s.homepage      = "https://github.com/datacite/omniauth-jwt-otp"
  s.summary       = "JWT one-time token strategy for OmniAuth"
  s.date          = Date.today
  s.description   = "Use short-lived JWT for one-time authentication, e.g. for passwordless authentication via email"
  s.require_paths = ["lib"]
  s.version       = OmniAuth::JwtOtp::VERSION
  s.extra_rdoc_files = ["README.md"]
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'omniauth', '~> 1.6', '>= 1.6.1'
  s.add_development_dependency 'jwt', '~> 1.5', '>= 1.5.1'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rack-test', '~> 0.6.3'
  s.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'
  s.add_development_dependency 'codeclimate-test-reporter', "~> 1.0.0"
  s.add_development_dependency 'simplecov'
end
