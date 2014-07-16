require "bundler/gem_tasks"

require 'rake/testtask'

desc 'Test the index_for plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

# If you want to make this the default task
task :default => :test