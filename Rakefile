require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rspec/core/rake_task'

Rake::ExtensionTask.new('wkhtml_native', Gem::Specification.load('wkhtml.gemspec')) do |ext|
  ext.ext_dir = 'ext/wkhtml'
  ext.lib_dir = 'lib/wkhtml'
end

task :console => [:compile, :build] do
  exec 'irb -r wkhtml -I ./lib'
end

RSpec::Core::RakeTask.new(:spec)
task :spec => [:compile, :build]

task :default => :spec