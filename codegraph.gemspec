$:.push File.expand_path("../lib", __FILE__)

require "codegraph/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "codegraph"
  s.version     = CodeGraph::VERSION
  s.authors     = ["Jan Xie"]
  s.email       = ["jan.h.xie@gmail.com"]
  s.homepage    = "https://github.com/janx/codegraph"
  s.summary     = "Generate graphviz graphs for your code."
  s.description = "Use codegraph to generate all kinds of graphviz graphs for you code, to visualize things like class hierarchy."

  s.executables = %w(codegraph)
  s.default_executable = "codegraph"
  s.files = Dir["{lib,bin}/**/*"] + ["LICENSE", "README.markdown"]

  s.add_dependency "ruby-graphviz", ">= 1.0.0"
end
