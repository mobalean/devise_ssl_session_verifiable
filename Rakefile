# encoding: UTF-8
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run all tests'
task :default => :test

desc 'Run Devise unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
