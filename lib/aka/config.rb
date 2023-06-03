require 'thor'
require 'fileutils'

module Aka
  AKA_PATH="#{Dir.home}/.aka"
  CONFIG_PATH="#{Dir.home}/.aka/.config"
  BASHRC_PATH="#{Dir.home}/.bashrc"
  ZSH_PATH="#{Dir.home}/.zshrc"

  def self.exist_statement(statement)
    puts "Exist: ".green + statement
  end

  def self.print_all_helpful_statement
    puts "A total of #{count()} aliases, #{count_groups} groups, #{count_export} exports and #{count_function} functions from #{read_YML("#{CONFIG_PATH}")["dotfile"]}"
    puts "\nUse 'aka -h' to see all the useful commands.\n\n"
  end

  def self.error_statement(statement)
    puts "Error: ".red + statement
  end

  def self.print_helpful_statement total_aliases
    puts "\nA total of  #{total_aliases} aliases in this project #{Dir.pwd}"
    puts "\nUse 'aka -h' to see all the useful commands."
  end

  def self.print_title(with_these)
    puts ""
    puts "*** #{with_these} ***"
    puts ""
  end

  def self.edit_statement(statement)
    puts "Edited:  ".yellow + statement
  end

  def self.create_statement(statement)
    puts "Created: ".green +  statement
  end


  #generates a string composed of spaces. The number of spaces is determined by subtracting the length of the input word from 20, 
  #unless this difference is less than zero, in which case no spaces are returned
  def self.show_space(word)
    spaces_needed = [20 - word.size, 0].max
    ' ' * spaces_needed
  end

  # generates a string that represents a visual progress bar along with the percentage it represents. It is intended to display a progress bar of a total length of 50 characters.
  def self.show_bar(percent)
    val = (percent / 100.0 * 50).round
    val = 2 if val.between?(1, 2)
    val = [val, 1].max  # Ensure there's always at least one "+"
    
    filled_bar = '+' * val
    empty_bar = '-'.red * (50 - val)
    
    "#{filled_bar}#{empty_bar} #{percent.round(2)}%"
  end

  def self.reload_dot_file
    is_ZSH? == true ? system("exec zsh") : system("kill -SIGUSR1 #{Process.ppid}")
  end

  def self.unalias_the value
    if is_ZSH? == true
      system("exec zsh")
    else
      system "echo '#{value}' > ~/sigusr1-args;"
      system "kill -SIGUSR2 #{Process.ppid}"
    end
  end

  def self.setup_aka
    userBash = []
    # 1. check for each type of file without setting anything.
    if File.exist?("#{ZSH_PATH}") #if zshrc exist
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

      puts ("Where do you wish to setup aka? (Pick a number and enter)\n")
      choice = STDIN.gets.chomp
    
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
  end

  def self.set_to_dotfile(filename)
    if filename == ".zshrc"
      set_ZSH
    elsif filename == ".bashrc"
      set_BASH
    # elsif filename == ".bash_profile"
    #   setBASH2
    # elsif filename == ".profile"
    #   setPROFILE
    end
  end

  def self.setup_autosource
    if File.exist?("#{AKA_PATH}")
      FileUtils.touch("#{AKA_PATH}/autosource")
      out_file = File.new("#{AKA_PATH}/autosource", "w")
      out_file.puts("export HISTSIZE=10000")
      out_file.puts("sigusr2() { unalias $1;}")
      out_file.puts("sigusr1() { source #{read_YML("#{CONFIG_PATH}")["dotfile"]}; history -a; echo 'reloaded dot file'; }")
      out_file.puts("trap sigusr1 SIGUSR1")
      out_file.puts("trap 'sigusr2 $(cat ~/sigusr1-args)' SIGUSR2")
      out_file.close
      autosource = "\nsource \"#{AKA_PATH}/autosource\""
      append(autosource, read_YML("#{CONFIG_PATH}")['profile'])
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


  def self.show_config
    config = YAML.load_file(CONFIG_PATH)
  
    puts "\n"
    config.each do |company, details|
      puts "#{company} -> #{details}".red
    end
  end
  
  def self.set_ZSH #ryan - set the right dotfile and profile
    set_path("#{ZSH_PATH}","dotfile")
    set_path("#{Dir.home}/.zsh_history","history")
    set_path("#{ZSH_PATH}","profile")
    set_path("#{AKA_PATH}","home")
  end

  def self.set_BASH #ryan - set the right dotfile and profile
    set_path("#{BASHRC_PATH}","dotfile")
    set_path("#{Dir.home}/.bash_history","history")
    set_path("#{BASHRC_PATH}","profile")
    set_path("#{AKA_PATH}","home")
  end

  def self.is_ZSH?
    read_YML("#{CONFIG_PATH}")["dotfile"] == "#{ZSH_PATH}" ? true : false
  end

end
