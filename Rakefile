task :default do
  system "ruby tests/test.rb"
end

task :console do
  require 'irb'
  require 'irb/completion'
  ARGV.clear
  IRB.start
end
