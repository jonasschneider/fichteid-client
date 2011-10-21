# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fichteid-client/version"

Gem::Specification.new do |s|
  s.name        = "fichteid-client"
  s.version     = Fichteid::Client::VERSION
  s.authors     = ["Jonas Schneider"]
  s.email       = ["mail@jonasschneider.com"]
  s.homepage    = ""
  s.summary     = %q{FichteID client}
  s.description = %q{Authenticate via http://fichteid.heroku.com}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "ruby-openid", "~> 2.1.8"
end
