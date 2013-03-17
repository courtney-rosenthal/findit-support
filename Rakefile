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
require 'rubygems/package_task'

gemspec = Gem::Specification.load("findit-support.gemspec")

Gem::PackageTask.new(gemspec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
