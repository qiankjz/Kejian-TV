#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Sub::Application.load_tasks

# c.f.  minitest-rails / lib / minitest / rails / tasks / minitest.rake 
Rake::TestTask.new(:default) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end
Rake::TestTask.new(:psvr_model_tests) do |t|
  t.libs << "test"
  t.test_files = FileList['test/models/*_test.rb']
  t.verbose = true
end
