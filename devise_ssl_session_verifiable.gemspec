# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_ssl_session_verifiable/version"

Gem::Specification.new do |s|
  s.name        = "devise_ssl_session_verifiable"
  s.version     = DeviseSslSessionVerifiable::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Secure access to SSL based pages while sharing a common session between HTTP and HTTPS"
  s.email       = "info@mobalean.co,"
  s.homepage    = "http://github.com/mobalean/devise_ssl_session_verifiable"
  s.description = "Secure access to SSL based pages while sharing a common session between HTTP and HTTPS"
  s.authors     = ['Michael Reinsch']

  s.rubyforge_project = "devise_ssl_session_verifiable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("devise", "> 3.2")
  s.add_dependency("railties", ">= 4.0.0")
end
