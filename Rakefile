require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
task :default => :spec

desc "Run IRB console with app environment"
task :console do
  puts "Loading development console..."
  system("irb -r ./lib/aka.rb")
end

