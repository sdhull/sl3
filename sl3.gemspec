$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sl3/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sl3"
  s.version     = Sl3::VERSION
  s.authors     = ["Steve Hull, TaskRabbit"]
  s.email       = ["steve@taskrabbit.com"]
  s.homepage    = "TaskRabbit.com"
  s.summary     = "SearchLogic 3 (developed on Rails 3.1)"
  s.description = "Syntactic sugar for finding things with AR"

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1.3"

  s.add_development_dependency "sqlite3"
end
