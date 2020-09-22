module Aka
  class Base < Thor

    desc :setup, 'setup aka'
    method_options reset: :boolean
    def setup

      if options[:reset] && File.exist?("#{CONFIG_PATH}")
        Aka.remove_autosource
        FileUtils.rm_r("#{CONFIG_PATH}")
        puts "#{CONFIG_PATH} is removed"
      end

      if File.exist?("#{CONFIG_PATH}")
        puts ".aka exists at #{CONFIG_PATH}"
        puts 'Please run [aka setup --reset] to remove .aka and setup again'
      else
        Aka.setup_config      # create and setup .config file
        Aka.setup_aka         # put value in .config file
        puts 'setting up autosource'
        Aka.setup_autosource  # create, link source file
        puts "Congratulation, aka is setup at #{CONFIG_PATH}"
      end
    end
    
  end
end
