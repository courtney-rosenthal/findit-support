task :default => [:test]

PKG_VERSION = "0.1.0"

########################################################################
  
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:test) do |test|
end

########################################################################
  
require 'rdoc/task'

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

########################################################################
  
require 'rubygems'

gemspec = Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "findit-support"
  s.version     = PKG_VERSION
  s.author      = "Chip Rosenthal"
  s.email       = "chip@unicom.com"
  s.homepage    = "https://github.com/chip-rosenthal/findit-support"
  s.summary     = "Support classes and functions for Find It Nearby geospatial application."
  s.description = <<-_EOT_
    The "Find It Support" package contains the application independent
    functions to support the "Find It Nearby" application.
 _EOT_
  
  s.add_dependency("sequel", ">= 3.45.0")
  s.add_dependency("sqlite3", ">= 1.3.7")
  s.add_dependency("json", ">= 1.7.7")  
  
  s.add_development_dependency('rspec')
  
  s.test_files = Dir["spec/**/*"]
  
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.rdoc)
  
  s.files = Dir["lib/**/*.rb"] + s.test_files + s.extra_rdoc_files
  
end

require 'rubygems/package_task'

Gem::PackageTask.new(gemspec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
