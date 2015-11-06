require 'aka/version'
require 'yaml'
require 'thor'
require 'shellwords'
require 'fileutils'

module Aka2
  class Base < Thor
    check_unknown_options!
    package_name "aka"
    default_task :list
    map "g" => "generate",
        "d" => "destroy",
        "f" => "find",
        "u" => "usage",
        "l" => "list",
        "e" => "edit",
        "c" => "clean",
        "h" => "help"

    desc "generate", ""
    def generate the_name=""
      puts "boo"
    end


  end

end
