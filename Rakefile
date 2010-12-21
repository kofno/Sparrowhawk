require "rubygems"
require "bundler/setup"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'


task :default => [:spec, :features]

RSpec::Core::RakeTask.new

Cucumber::Rake::Task.new :features do |t|
  t.cucumber_opts = "--color --format progress"
end
