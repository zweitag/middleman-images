# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-images/version"

Gem::Specification.new do |s|
  s.name = "middleman-images"
  s.version = MiddlemanImages::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.licenses = ["MIT"]
  s.authors = ["Ruben Grimm", "Julian Schneider"]
  s.email = ["ruben.grimm@zweitag.de", "julian.schneider@zweitag.de"]
  s.homepage = "https://www.github.com/zweitag/middleman-images"
  s.summary = "Resize and optimize images for Middleman"
  s.description = "Resize and optimize images for Middleman"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.5.0"

  s.add_runtime_dependency("middleman-core", [">= 4.1.14"])
end
