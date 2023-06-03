require 'aka/version'
require 'aka/helpers'
require 'aka/config'
require 'yaml'
require 'shellwords'
require 'open-uri'

# import everything from commands folder
Dir[File.join(__dir__, 'commands', '*.rb')].each do |file|
    require_relative file
end
  