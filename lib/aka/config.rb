require 'thor'
require 'fileutils'

module Aka
  def self.setup_aka
    userBash = []
    # 1. check for each type of file without setting anything.
    if File.exist?("#{ZSHRC_PATH}") #if zshrc exist
      userBash.push(".zshrc")
    end
    if File.exist?("#{BASHRC_PATH}") #if bashrc exist
      userBash.push(".bashrc")
    end
    if File.exist?("#{BASH_PROFILE_PATH}") #if bash_profile exist
      userBash.push(".bash_profile")
    end
    if File.exist?("#{PROFILE_PATH}") #if .profile exist
      userBash.push(".profile")
    end

    #2. count the number of types

    #3 if number of types is 1, proceed to set it
    if userBash.count == 1
      set_to_dotfile(userBash.first)

    elsif userBash.count > 1
      #4 if the number of types is more than 1, proceed to ask which one does the users want to uses.
      userBash.each_with_index do |choice,i|
        puts "#{i+1}. Setup at #{Dir.home}/#{choice}"
      end

      choice = ask "Where do you wish to setup aka? (Pick a number and enter)\n"
      case choice
        when "1"
          set_to_dotfile(userBash[0]) if userBash[0]
        when "2"
          if userBash[1] then set_to_dotfile(userBash[1]) else abort "No file choosen" end
        when "3"
          if userBash[2] then set_to_dotfile(userBash[2]) else abort "No file choosen" end
        when "4"
          if userBash[3] then set_to_dotfile(userBash[3]) else abort "No file choosen" end
        else
          puts "Invalid input, Please enter the number between 1 and #{userBash.count}. Please try again"
          abort "No file choosen"
      end
    end #if userBash > 1

      # if File.exist?("#{ZSHRC_PATH}") #if zshec exist
      #   setZSHRC2
      # elsif File.exist?("#{BASHRC_PATH}") #if bashrc exist
      #   setBASHRC2
      # elsif File.exist?("#{BASH_PROFILE_PATH}") #if bash_profile exist
      #   setBASH2
      # else
      #   puts "Aka2 only supports zshrc, bashrc and bash_profile"
      #   puts "Please contact http://github.com/ytbryan for more info."
      # end
  end


  def self.set_to_dotfile(filename)
    if filename == ".zshrc"
      setZSHRC2
    elsif filename == ".bashrc"
      setBASHRC2
    elsif filename == ".bash_profile"
      setBASH2
    elsif filename == ".profile"
      setPROFILE
    end
  end

  def self.setup_autosource
    if File.exist?("#{AKA_PATH}")
      FileUtils.touch("#{AKA_PATH}/autosource")
      out_file = File.new("#{AKA_PATH}/autosource", "w")
      out_file.puts("export HISTSIZE=10000")
      out_file.puts("sigusr2() { unalias $1;}")
      out_file.puts("sigusr1() { source #{readYML("#{CONFIG_PATH}")["dotfile"]}; history -a; echo 'reloaded dot file'; }")
      out_file.puts("trap sigusr1 SIGUSR1")
      out_file.puts("trap 'sigusr2 $(cat ~/sigusr1-args)' SIGUSR2")
      out_file.close
      autosource = "\nsource \"#{AKA_PATH}/autosource\""
      append(autosource, readYML("#{CONFIG_PATH}")['profile'])
      puts "Done. Please restart this shell.".red
    else
      puts "Directory #{CONFIG_PATH} doesn't exist"
    end
  end
  def self.setup_config
    if File.exist?("#{CONFIG_PATH}")
      puts "Directory #{CONFIG_PATH} exist"
    else
      FileUtils.mkdir_p("#{AKA_PATH}")
      FileUtils.touch("#{CONFIG_PATH}")
      out_file = File.new("#{CONFIG_PATH}", "w")
      out_file.puts("---")
      out_file.puts("dotfile: \"/home/user/.bashrc\"")
      out_file.puts("history: \"/home/user/.bash_history\"")
      out_file.puts("home: \"/home/user/.aka\"")
      out_file.puts("install: \"/usr/local/bin\"")
      out_file.puts("profile: \"/home/user/.bashrc\"")
      out_file.puts("list: 20")
      out_file.puts("usage: 20")
      out_file.puts("remote: 12.12.12.21")
      out_file.close
    end
  end

  def self.showConfig
    thing = YAML.load_file("#{CONFIG_PATH}")
    puts ""
    thing.each do |company,details|
      puts "#{company} -> " + "#{details}".red
    end
  end

  def self.setZSHRC
    setPath("#{ZSHRC_PATH}","dotfile")
    setPath("#{Dir.home}/.zsh_history","history")
    setPath("/etc/zprofile","profile")
  end

  def self.setBASHRC
    setPath("#{BASHRC_PATH}","dotfile")
    setPath("#{Dir.home}/.bash_history","history")
    setPath("/etc/profile","profile")
  end

  def self.setBASH
    setPath("#{BASH_PROFILE_PATH}","dotfile")
    setPath("#{Dir.home}/.bash_history","history")
    setPath("/etc/profile","profile")
  end

  def self.setZSHRC2 #ryan - set the right dotfile and profile
    setPath("#{ZSHRC_PATH}","dotfile")
    setPath("#{Dir.home}/.zsh_history","history")
    setPath("#{ZSHRC_PATH}","profile")
    setPath("#{AKA_PATH}","home")
  end

  def self.setBASHRC2 #ryan - set the right dotfile and profile
    setPath("#{BASHRC_PATH}","dotfile")
    setPath("#{Dir.home}/.bash_history","history")
    setPath("#{BASHRC_PATH}","profile")
    setPath("#{AKA_PATH}","home")
  end

  def self.setBASH2 #ryan - set the right dotfile and profile
    setPath("#{BASH_PROFILE_PATH}","dotfile")
    setPath("#{Dir.home}/.bash_history","history")
    setPath("/etc/profile","profile")
    setPath("#{AKA_PATH}","home")
  end

  def self.setPROFILE
    setPath("#{PROFILE_PATH}","dotfile")
    setPath("#{Dir.home}/.bash_history","history")
    setPath("/etc/profile","profile")
    setPath("#{AKA_PATH}","home")
  end

  def self.isOhMyZsh
    readYML("#{CONFIG_PATH}")["dotfile"] == "#{ZSHRC_PATH}" ? true : false
  end

end
