require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rspec/core/rake_task'

Rake::ExtensionTask.new('wkhtml', Gem::Specification.load('wkhtml.gemspec'))

task :console => [:compile, :build] do
  exec 'irb -r wkhtml -I ./lib'
end

RSpec::Core::RakeTask.new(:spec)
task :spec => [:compile, :build]

task :default => :spec