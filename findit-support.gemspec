
require "./lib/findit-support/version.rb"

Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = "findit-support"
  spec.version     = FindIt::Support::VERSION
  spec.author      = "Chip Rosenthal"
  spec.email       = "chip@unicom.com"
  spec.homepage    = "https://github.com/chip-rosenthal/findit-support"
  spec.summary     = "Support classes and functions for Find It Nearby geospatial application."
  spec.description = <<-_EOT_
    The "Find It Support" package contains the application independent
    functions to support the "Find It Nearby" application.
 _EOT_
  
  spec.test_files = Dir["spec/**/*"]
  
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w(README.rdoc)
  
  spec.files = Dir["lib/**/*.rb"] + spec.test_files + spec.extra_rdoc_files
  
  spec.add_dependency("sequel", "~> 3.45.0")
  spec.add_dependency("sqlite3", "~> 1.3.7")
  spec.add_dependency("json_pure", "~> 1.7.7")  
  
  spec.add_development_dependency('rspec')
end
