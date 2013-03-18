#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "specs"
  t.test_files = FileList['specs/**/*_spec.rb']
  t.verbose = true
end
