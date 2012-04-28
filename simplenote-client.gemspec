# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "simplenote-client"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = "2012-04-29"
  s.description = "This gem provides a CLI program to send commands to the Simplenote API."
  s.email = "flori@ping.de"
  s.executables = ["simplenote"]
  s.extra_rdoc_files = ["README.rdoc", "lib/simplenote/client/version.rb", "lib/simplenote/error.rb", "lib/simplenote/api.rb", "lib/simplenote/commands.rb", "lib/simplenote/client.rb", "lib/simplenote/response_object.rb", "lib/simplenote.rb"]
  s.files = [".gitignore", "Gemfile", "README.rdoc", "Rakefile", "VERSION", "bin/simplenote", "lib/simplenote.rb", "lib/simplenote/api.rb", "lib/simplenote/client.rb", "lib/simplenote/client/version.rb", "lib/simplenote/commands.rb", "lib/simplenote/error.rb", "lib/simplenote/response_object.rb", "simplenote-client.gemspec"]
  s.homepage = "http://github.com/flori/simplenote-client"
  s.rdoc_options = ["--title", "Simplenote-client - Client application for the Simplenote API", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Client application for the Simplenote API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 0.1.7"])
      s.add_runtime_dependency(%q<tins>, ["~> 0.4.1"])
      s.add_runtime_dependency(%q<term-ansicolor>, ["~> 1.0"])
      s.add_runtime_dependency(%q<dslkit>, ["~> 0.2.10"])
      s.add_runtime_dependency(%q<json>, ["~> 1.7.0"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.8.0"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 0.1.7"])
      s.add_dependency(%q<tins>, ["~> 0.4.1"])
      s.add_dependency(%q<term-ansicolor>, ["~> 1.0"])
      s.add_dependency(%q<dslkit>, ["~> 0.2.10"])
      s.add_dependency(%q<json>, ["~> 1.7.0"])
      s.add_dependency(%q<httparty>, ["~> 0.8.0"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 0.1.7"])
    s.add_dependency(%q<tins>, ["~> 0.4.1"])
    s.add_dependency(%q<term-ansicolor>, ["~> 1.0"])
    s.add_dependency(%q<dslkit>, ["~> 0.2.10"])
    s.add_dependency(%q<json>, ["~> 1.7.0"])
    s.add_dependency(%q<httparty>, ["~> 0.8.0"])
  end
end
