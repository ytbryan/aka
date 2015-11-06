require 'aka/version'
require 'yaml'
require 'thor'
require 'shellwords'
require 'fileutils'

module Aka
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

    desc "import", "import project alias into your system alias"
    method_option :all, :type => :boolean, :aliases => '-a', :desc => 'import all .aka'
    def import the_name=""
      if the_name == ""
        array = get_all_aliases_from_proj_aka()
        repeated_system_call(array)
      else
        array = get_all_aliases_from_proj_aka(the_name)
        repeated_system_call(array)
      end
    end

    # desc "sync", "sync project aliases with system aliases"
    # def sync
    #   array = get_all_aliases_from_proj_aka()
    #   repeated_system_call(array)
    # end

    # desc "test", "test and show that this won't work"
    # def test
    #   # system("source ~/.bash_profile")
    #   system("aka g test='echo something'")
    # end

    #
    # Func
    #
    # desc "func", "generate function"
    # def func args
    #   #generate the file
    #   result = add_with_group(parseARGS(args), options.group) if args
    #   FileUtils.touch("#{Dir.pwd}/.aka")
    #   add_func_to_proj(args)
    #   reload_dot_file if result == true && !options.no
    # end

    #
    # Groups
    #
    desc "groups", "list all the groups"
    def groups
      print_title("System Groups")
      list_all_groups()
    end

    #
    # Install
    #
    # desc "install", "This will run the install script for git, rbenv, latest ruby"
    # def install
    #   system("~/.aka/install.sh")
    # end

    #
    # Where is your dotfile
    # aka where
    desc "where", "locate your dotfile"
    def where
      puts readYML("#{Dir.pwd}/.aka/.config")["dotfile"]
    end

    #
    # Export
    #
    desc "export", "export system alias into project alias"
    method_option :force, :type => :boolean, :aliases => '-f', :desc => ''
    method_option :name, :type => :string, :aliases => '-n', :desc => ''
    def export the_name
      array = export_group_aliases(the_name)
      if options.name?
        new_proj_aka = "#{options.name}"+".aka"
        FileUtils.touch(new_proj_aka)
        write_with_array_into(new_proj_aka, array)
      else
        if File.exist?('proj.aka')
          if options.force?
            write_with_array_into('proj.aka', array)
          else
            puts "Exists: ".green + "proj.aka already exists. Use -f to recreate a proj.aka"
          end
        else
          FileUtils.touch('proj.aka')
          write_with_array_into('proj.aka', array)
        end
      end
    end

    #################
    # PROJ
    #################
    desc "proj", "list the project alias (short alias: p)"
    method_option :group, :type => :boolean, :aliases => '-g'
    method_option :load, :type => :string, :aliases => '-i'
    method_option :save, :type => :string, :aliases => '-e'
    def proj
      if options.group? && File.exist?('proj.aka')
        print_title("Project Groups")
        list_all_groups_in_proj_aka()
      elsif options.group? && !File.exist?('proj.aka')
        puts "Error: ".red + "The proj.aka is missing. Please run [aka export <name_of_group>] to generate proj.aka file"
      else
        print_title("Project Alias")
        if File.exist?('proj.aka')
          if content = File.open('proj.aka').read
            content.gsub!(/\r\n?/, "\n")
            content_array = content.split("\n")
            answer_count = print_the_aliases(content_array)
            print_helpful_statement(answer_count)
          end
        else
          print_error_statement()
        end
      end
    end

    #################
    # GENERATE
    #################
    desc "generate", "generate an alias (short alias: g)"
    method_option :last, :type => :boolean, :aliases => '-l', :desc => ''
    method_option :group, :type => :string, :aliases => '-g', :desc => '', :default => 'default'
    method_option :no, :type => :boolean, :aliases => '-n', :desc => '--no means do not reload'
    method_option :empty, :type => :boolean, :aliases => '-e', :desc => 'do not print anything'
    def generate args
      result = false
      if options.last?
        result = add_with_group(add_last_command(parseARGS(args))) if args
      else
        result = add_with_group(parseARGS(args), options.group) if args
      end
      reload_dot_file if result == true && !options.no
    end

    #
    # DESTROY
    #
    desc "destroy", "destroy an alias (short alias: d)"
    method_options :force => :boolean
    method_option :no, :type => :boolean, :aliases => '-n', :desc => '--no means do not reload'
    def destroy(*args)
      args.each_with_index do |value, index|
        result = remove(value)
        unalias_the(value) if !options.nounalias && result == true
        reload_dot_file if result == true && !options.no
      end
    end

    #
    # first step: set config file
    #
    desc "setup", "Gem - Setup aka"
    method_options :reset => :boolean
    def setup
      configDir = "#{Dir.home}/.aka"
      if options.reset? && File.exist?("#{configDir}")
        remove_autosource
        FileUtils.rm_r("#{configDir}")
        puts "#{configDir} is removed"
      end

      if File.exist?("#{configDir}/.config")
        puts ".aka config file is exist in #{configDir}"
        puts "Please run [aka setup --reset] to remove aka file and setup again"
      else
        setup_config      # create and setup .config file
        setup_aka         # put value in .config file
        puts "setting up autosource"
        setup_autosource  # create, link source file
        puts "Congratulation, aka is setup in #{configDir}"
      end
    end

    #
    # FIND
    #
    desc "find", "find an alias (short alias: f)"
    method_options :force => :boolean
    method_option :group, :type => :string, :aliases => '-g', :desc => ''
    def find *args
      if options.group
        search_alias_with_group_name(options.group)
      else
        args.each_with_index do |value, index|
          search_alias_return_alias_tokens(value)
        end
      end
    end

    #
    # EDIT
    #
    desc "edit", "edit an alias(short alias: e)"
    method_options :force => :boolean
    method_options :name => :boolean #--name
    method_option :group, :type => :string, :aliases => '-g', :desc => '', :default => 'default'
    def edit args
      if options.group
          if options.group != 'default'
            puts "Editing for the following alias - "
            answer = ask "do you want to change the group from xxxx to #{options.group}?"
            change_group_name_with(options.group) if yes?
          else
            puts "TODO: The user did not enter a new alias group"
          end
      else
        puts "TODO: this should simply call the usual function"
        puts "no group is used"
      end

      if args
        values = args.split("=")
        if values.size > 1
          truth, _alias = search_alias_return_alias_tokens(args)
          if truth == true
            if options.name
              remove(_alias) #remove that alias
              edit_alias_name(values[1], _alias) #edit that alias
              reload_dot_file() if !options.noreload
            else
              remove(_alias) #remove that alias
              edit_alias_command(values[1], _alias) #edit that alias
              reload_dot_file() if !options.noreload
            end
          else
            puts "Alias '#{args}' cannot be found".red
          end
        else
          truth, _alias, command = search_alias_return_alias_tokens(args)
          if truth == true
            if options.name
              input = ask "Enter a new alias for command '#{command}'?\n"
              if yes? "Please confirm the new alias? (y/N)"
                remove(_alias) #remove that alias
                edit_alias_name(input, command) #edit that alias
                reload_dot_file() if !options.noreload
              end
            else
              input = ask "Enter a new command for alias '#{args}'?\n"
              if yes? "Please confirm the new command? (y/N)"
                remove(_alias) #remove that alias
                edit_alias_command(input, _alias) #edit that alias
                reload_dot_file() if !options.noreload
              end
            end
          else
            puts "Alias '#{args}' cannot be found".red
          end
        end
      end #if args
    end

    #
    # LIST OUT - ryan - remove numbering
    #
    desc "list", "list alias (short alias: l)"
    method_options :force => :boolean
    method_options :number => :boolean
    method_option :group, :type => :boolean, :aliases => '-g', :desc => ''
    def list(args=nil)
      print_title("System Alias")
      if args != nil
        showlast(options.number,args.to_i, options.group) #user input
      else
        value = readYML("#{Dir.home}/.aka/.config")["list"]
        if value.class == Fixnum
          showlast(options.number,value.to_i,options.group)
        else
          puts "List value is not defined in #{Dir.home}/.aka/.config"
          showlast(options.number,50,options.group)
        end
      end
      print_all_helpful_statement
      reload_dot_file
    end

    #
    # USAGE - ryan - remove numbering in front
    #
    desc "usage [number]", "show commands usage based on history"
    # method_options :least, :type => :boolean, :aliases => '-l', :desc => 'show the least used commands'
    # method_options :clear, :type => :boolean, :aliases => '-c', :desc => 'clear the dot history file'
    def usage(args=nil)
      if args
        if options.least
          showUsage(args.to_i, true) if args
        else
          showUsage(args.to_i) if args
        end
      else
        if options.least
          value = readYML("#{Dir.home}/.aka/.config")["usage"]
          showlast(value.to_i, true) #this is unsafe
        else
          value = readYML("#{Dir.home}/.aka/.config")["usage"]
          showlast(value.to_i) #this is unsafe
        end
      end

      if options[:clear]
        puts "clear the dot history file"
      end
    end

    #
    # Config
    #
    desc "config", "show config"
    def config()
      showConfig
    end

    #
    # INIT
    #
    desc "init", "setup aka"
    method_options :dotfile => :string
    method_options :history => :string
    method_options :home => :string
    method_options :install => :string
    method_options :profile => :string
    method_options :list => :numeric
    method_options :usage => :numeric
    method_options :remote => :string
    method_options :config => :boolean
    method_options :zshrc => :boolean
    method_options :bashrc => :boolean
    method_options :bash => :boolean

    def init
      if options.count < 1
        setup
      else
        setZSHRC if options[:zshrc]
        setBASHRC if options[:bashrc]
        setBASH if options[:bash]

        showConfig if options[:config]
        setPath(options[:dotfile],"dotfile") if options[:dotfile]
        setPath(options[:history],"history") if options[:history]
        setPath(options[:home],"home") if options[:home]
        setPath(options[:install],"install") if options[:install]
        setPath(options[:profile],"profile") if options[:profile]
        setPath(options[:list],"list") if options[:list]
        setPath(options[:usage],"usage") if options[:usage]
        setPath(options[:remote],"remote") if options[:remote]
      end
    end

    #
    # CLEAN
    #
    desc "clean", "perform cleanup on your dot file"
    def clean
      cleanup
    end

    #
    # PRIVATE METHODS
    #

    private

    def get_all_aliases_from_proj_aka str="proj.aka"
      array = []
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        array = print_the_aliases_return_array(content_array)
      end
      return array
    end

    # set path
    def setPath(path, value)
      data = readYML("#{Dir.home}/.aka/.config")
      if data.has_key?(value) == true
        old_path = data[value]
        data[value] = path
        writeYML("#{Dir.home}/.aka/.config", data)
        puts "#{value} -> #{path}"
      else
        puts "Error: ".red + "--#{value} does not exist in #{Dir.home}/.aka/.config "
      end
    end

    # reload
    def reload
      system "source #{readYML("#{Dir.home}/.aka/.config")["dotfile"]}"
    end

    # read YML
    def readYML path
      if File.exists? path
        return YAML.load_file(path)
      else
        puts "#{Dir.home}/.aka/.config does not exist. Type `aka setup` to setup the config file".red
      end
    end

    # write YML
    def writeYML path, theyml
      File.open(path, 'w') {|f| f.write theyml.to_yaml } #Store
    end

    def write_with_array_into path, array
      File.open(path, 'w') { |file|
        array.each do |line|
          file.write(line)
          file.write("\n")
        end
      }
    end


    # write_with + into dotfile
    def write_with array
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      File.open(str, 'w') { |file|
        array.each do |line|
          file.write(line)
        end
      }
    end

    # write_with_newline + into dotfile
    def write_with_newline array
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      File.open(str, 'w') { |file|
        array.each do |line|
          file.write(line + "\n")
        end
      }
    end

    # write
    def write str, path
      File.open(path, 'w') { |file| file.write(str) }
    end

    # append
    def append str, path
      File.open(path, 'a') { |file| file.write(str) }
    end

    #append_with_newline
    def append_with_newline str, path
      File.open(path, 'a') { |file| file.write(str + "\n") }
    end

    # reload_dot_file
    def reload_dot_file
      isOhMyZsh == true ? system("exec zsh") : system("kill -SIGUSR1 #{Process.ppid}")
    end

    # history write
    def historywrite
      isOhMyZsh == true ?  system("exec zsh") :  system("kill -SIGUSR2 #{Process.ppid}")
    end

    # unalias
    def unalias_the value
      if isOhMyZsh == true
        system("exec zsh")
      else
        system "echo '#{value}' > ~/sigusr1-args;"
        system "kill -SIGUSR2 #{Process.ppid}"
      end
    end

    #split domain user
    def split_domain_user fulldomain
      username = fulldomain.split("@").first
      domain = fulldomain.split("@")[1]
      return [username, domain]
    end

    # split
    def split fulldomain
      username = fulldomain.split("@").first
      domain = fulldomain.split("@")[1].split(":").first
      port = fulldomain.split("@")[1].split(":")[1]
      return [username, domain, port]
    end

    def add_with_group input, name_of_group
      if input && search_alias_return_alias_tokens(input).first == false && not_empty_alias(input) == false
        array = input.split("=")
        group_name = "# => #{name_of_group}"
        full_command = "alias #{array.first}='#{array[1]}' #{group_name}".gsub("\n","") #remove new line in command
        print_out_command = "aka g #{array.first}='#{array[1]}'"
        str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
        File.open(str, 'a') { |file| file.write("\n" +full_command) }
        puts "Created: ".green +  "#{print_out_command} " + "in #{name_of_group} group."
        return true
      else
        puts "The alias is already present. Use 'aka -h' to see all the useful commands."
        return false
      end
    end

    # add
    def add input
      if input && search_alias_return_alias_tokens(input).first == false && not_empty_alias(input) == false
        array = input.split("=")
        full_command = "alias #{array.first}='#{array[1]}'".gsub("\n","") #remove new line in command
        print_out_command = "aka g #{array.first}='#{array[1]}'"
        str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
        File.open(str, 'a') { |file| file.write("\n" +full_command) }
        puts "Created: ".green +  "#{print_out_command}"
        return true
      else
        puts "The alias is already present. Use 'aka -h' to see all the useful commands."
        return false
      end
    end

    # not empty alias
    def not_empty_alias input
      array = input.split("=")
      return true if array.count < 2
      return array[1].strip == ""
    end

    #list
    def search_alias_with_group_name name
      print_title("System Alias")
      group_count = 0
      if name == "group"
        name = "default"
        str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
        if content = File.open(str).read
          content.gsub!(/\r\n?/, "\n")
          content_array = content.split("\n")
          group_count = print_the_aliases(content_array)

          if group_count == 0
            puts "No alias found in default group"
          else
            puts ""
            puts "Exist: ".green + "A total of #{group_count} aliases in default group."
            puts ""
          end
        end
      else

        str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
        if content = File.open(str).read
          content.gsub!(/\r\n?/, "\n")
          content_array = content.split("\n")
          group_count = print_the_aliases2(content_array, name)
        end

        if group_count == 0
          puts "No alias found in #{name} group"
        else
          puts ""
          puts "Exist: ".green + "A total of #{group_count} aliases in #{name} group."
          puts ""
        end
      end
    end

    def export_group_aliases name
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      results = []
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        results = print_the_aliases_return_array2(content_array, name)
      end
      return results
    end

    # show alias
    def search_alias_return_alias_tokens argument
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")

        content_array.each_with_index { |line, index|
          line = line.gsub("# =>", "-g")
          value = line.split(" ")
          containsCommand = line.split('=') #containsCommand[1]
          if value.length > 1 && value.first == "alias"
            answer = value[1].split("=") #contains the alias
            if found?(answer.first, argument.split("=").first, line) == true
              this_alias = answer.first
              answer.slice!(0) #rmove the first
              containsCommand[1].slice!(0) &&  containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
              return [true, this_alias, containsCommand[1]]
            end
          end
        }
      else
        puts "#{@pwd} cannot be found.".red
        return [false, nil, nil]
      end
      return [false, nil, nil]

    end

    #
    # remove
    #
    def remove input
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          line = line.gsub("# =>", "-g")
          value = line.split(" ")
          if value.length > 1 && value.first == "alias"
            answer = value[1].split("=")
            if answer.first == input
              content_array.delete_at(index) && write_with_newline(content_array)
              print_out_command = "aka g #{input}=#{line.split("=")[1]}"
              puts "Removed: ".red  + "#{print_out_command}"
              return true
            end
          end
        }

        puts "#{input} cannot be found.".red
      else
        puts "#{@pwd} cannot be found.".red
        return false
      end
    end

    # remove autosource in dotfile
    def remove_autosource
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          if line == "source \"/home/ryan/.aka/autosource\""
            content_array.delete_at(index) && write_with_newline(content_array)
            puts "Removed: ".red + "source \"/home/ryan/.aka/autosource\""
            return true
          end
        }
      else
        puts "Error: ".red + "autosource cannot be found in dotfile."
        return false
      end
    end

    # history
    def history
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["history"])
      if content = File.open(str).read
        puts ".bash_history is available"
        count=0
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        content_array.each_with_index { |line, index|
          array = line.split(" ")
          if array.first == "alias"
            count += 1
          end
          puts "#{index+1} #{line}"
        }
        puts "There are #{count} lines of history."
      else
        puts ".bash_history is not available".red
      end
    end


    def  create_proj_file the_name
      array = export_group_aliases(the_name)
      if File.exist?('proj.aka')
        if options.force?
          File.open('proj.aka', 'w') { |file|
            array.each do |line|
              file.write(line)
              file.write("\n")
            end
          }
        else
          puts "Exists: ".green + "proj.aka already exists. Use -f to recreate a proj.aka"
        end
      else
        FileUtils.touch('proj.aka')
        File.open('proj.aka', 'w') { |file|
          array.each do |line|
            file.write(line)
            file.write('\n')
          end
        }
      end
    end

    def generate_proj_aka_file the_name
      array = export_group_aliases(the_name)
      if File.exist?('proj.aka')
        if options.force?
          File.open('proj.aka', 'w') { |file|
            array.each do |line|
              file.write(line)
              file.write("\n")
            end
          }
        else
          puts "Exists: ".green + "proj.aka already exists. Use -f to recreate a proj.aka"
        end
      else
        FileUtils.touch('proj.aka')
        File.open('proj.aka', 'w') { |file|
          array.each do |line|
            file.write(line)
            file.write('\n')
          end
        }
      end
    end


    # check version
    def version
      puts ""
      puts "aka #{program(:version)} - #{program(:last_update)}"
      puts "#{program(:author)} - #{program(:contact)}"
      puts "https://github.com/ytbryan/aka"
    end

    # check found
    def found? answer, argument, line
      if answer == argument
        puts "Exist:  ".green + " aka g #{argument}=#{line.split('=')[1]}"
        return true
      else
        return false
      end
    end

    def edit_alias_command newcommand, this_alias
      puts "Edited:  ".yellow + "aka g #{this_alias}='#{newcommand}'"
      return append("alias " + this_alias + "='" + newcommand + "'", readYML("#{Dir.home}/.aka/.config")["dotfile"] )
    end

    # edit alias
    def edit_alias_name newalias, thiscommand
      puts "Edited:  ". yellow + "aka g #{newalias}='#{thiscommand}'"
      return append("alias " + newalias + "='" + thiscommand + "'", readYML("#{Dir.home}/.aka/.config")["dotfile"] )
    end

    def count_groups
      group_counts = 0
      group_array = []
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == 'alias'
            answer = value[1].split("=") #contains the alias
            group_name = line.scan(/# => ([a-zA-z]*)/).first if line.scan(/# => ([a-zA-z]*)/)
            group_array.push(group_name) if group_name != nil
          end
        }
        return group_array.uniq.count
      end
    end

    # count function
    def count_function
      function_count = 0
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == "function"
            answer = value[1].split("=")
            function_count += 1
          end
        }
        return function_count
      end
    end

    #count export
    def count_export
      export_count = 0
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == "export"
            answer = value[1].split("=")
            export_count += 1
          end
        }
        return export_count
      end

    end

    # count
    def count
      alias_count = 0

      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])

      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == "alias"
            answer = value[1].split("=")
            alias_count += 1
          end
        }
        return alias_count
      end
    end



    # setup_aka by ryan - set value in config file
    def setup_aka
      userBash = []
      # 1. check for each type of file without setting anything.
      if File.exist?("#{Dir.home}/.zshrc") #if zshrc exist
        userBash.push(".zshrc")
      end
      if File.exist?("#{Dir.home}/.bashrc") #if bashrc exist
        userBash.push(".bashrc")
      end
      if File.exist?("#{Dir.home}/.bash_profile") #if bash_profile exist
        userBash.push(".bash_profile")
      end
      if File.exist?("#{Dir.home}/.profile") #if .profile exist
        userBash.push(".profile")
      end

      #2. count the number of types

      #3 if number of types is 1, proceed to set it
      if userBash.count == 1
        set_to_dotfile(userBash.first)

      elsif userBash.count > 1
        #4 if the number of types is more than 1, proceed to ask which one does the users want to uses.
        userBash.each_with_index do |choice,i|
          puts "#{i+1}. Setup in #{Dir.home}/#{choice}"
        end
        choice = ask "Please choose which location you wish to setup? (Choose a number and enter)\n"

        #5 once you receive input, then you set it according to input
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

        # if File.exist?("#{Dir.home}/.zshrc") #if zshec exist
        #   setZSHRC2
        # elsif File.exist?("#{Dir.home}/.bashrc") #if bashrc exist
        #   setBASHRC2
        # elsif File.exist?("#{Dir.home}/.bash_profile") #if bash_profile exist
        #   setBASH2
        # else
        #   puts "Aka2 only supports zshrc, bashrc and bash_profile"
        #   puts "Please contact http://github.com/ytbryan for more info."
        # end
    end

    def set_to_dotfile(filename)
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


    # setup_autosource by ryan - create source file
    def setup_autosource
      configDir = "#{Dir.home}/.aka"

      if File.exist?("#{configDir}/.config")
        out_file = File.new("#{configDir}/autosource", "w")
        out_file.puts("export HISTSIZE=10000")
        out_file.puts("sigusr2() { unalias $1;}")
        out_file.puts("sigusr1() { source #{readYML("#{configDir}/.config")["dotfile"]}; history -a; echo 'reloaded dot file'; }")
        out_file.puts("trap sigusr1 SIGUSR1")
        out_file.puts("trap 'sigusr2 $(cat ~/sigusr1-args)' SIGUSR2")
        out_file.close
        autosource = "\nsource \"#{configDir}/autosource\""
        append(autosource, readYML("#{configDir}/.config")['profile'])
        puts "Done. Please restart this shell.".red
      else
        puts "Directory #{configDir}/.config doesn't exist"
      end
    end

    # create and setup config file
    def setup_config
      configDir = "#{Dir.home}/.aka"
      if File.exist?("#{configDir}/.config")
        puts "Directory #{configDir}/.config exist"
      else
        FileUtils::mkdir_p("#{configDir}")
        out_file = File.new("#{configDir}/.config", "w")
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

    # write to location
    def write_to_location location, address
      # does_aka_directory_exists ? write(location, address) : puts ".aka not found.".red
      if does_aka_directory_exists
        write(location, address)
      else
        puts ".aka not found.".red
      end
    end

    # read location
    def read location
      answer = dot_location_exists?(location)
      answer == true && content = File.open(location).read ? content : ""
    end

    # dot location exist
    def dot_location_exists? address
      File.exist? address
    end

    # aka directory exist ?
    def does_aka_directory_exists
      File.directory?("#{Dir.home}/.aka")
    end

    # check config file
    def is_config_file_present? str
      path =  "#{Dir.home}/.bash_profile"
      if str == ""
        puts "Error: ".red + "Type `aka init --dotfile #{path}` to set the path to your dotfile. \nReplace .bash_profile with .bashrc or .zshrc if you are not using bash."
        exit()
      end

      if !File.exists?(str)
        puts "Error: ".red + "Type `aka init --dotfile #{path}` to set the path of your dotfile. \nReplace .bash_profile with .bashrc or .zshrc if you are not using bash."
        exit()
      end

      return str
    end

    # show last
    def showlast_old howmany=10
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        #why not just call the last five lines? Because i can't be sure that they are aliases
        total_aliases = []
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == "alias"
            total_aliases.push(line)
          end
        }
        puts ""
        if total_aliases.count > howmany
          total_aliases.last(howmany).each_with_index do |line, index|
            splitted= line.split('=')
            puts "#{total_aliases.count - howmany + index+1}. aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
          end
        else
          total_aliases.last(howmany).each_with_index do |line, index|
            splitted= line.split('=')
            puts "#{index+1}. aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
          end
        end
        puts ""
      end
    end

    def show_last_with_group(list_number=false, howmany=10, group)
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        total_aliases = []
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == "alias"
            total_aliases.push(line)
          end
        }
        puts ""
        if total_aliases.count > howmany
          total_aliases.last(howmany).each_with_index do |line, index|
            splitted= line.split('=')
            if list_number
              puts "#{total_aliases.count - howmany + index+1}. aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            else
              puts "aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            end
          end
        else
          total_aliases.last(howmany).each_with_index do |line, index|
            splitted= line.split('=')
            if list_number
              puts "#{index+1}. aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            else
              puts "aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            end
          end
        end
        puts ""
      end
    end

    # show last2 - ryan - remove number
    def showlast(list_number=false,howmany=10, showGroup)
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])

      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        #why not just call the last five lines? Because i can't be sure that they are aliases
        total_aliases = []
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == "alias"
            total_aliases.push(line)
          end
        }
        puts ""
        if total_aliases.count > howmany #if there is enogh alias
          total_aliases.last(howmany).each_with_index do |line, index|
            line = line.gsub("# =>", "-g")
            splitted= line.split('=')
            if list_number
              puts "#{total_aliases.count - howmany + index+1}. aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            else
              puts "aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            end
          end
        else #if there is not enough alias
          total_aliases.last(howmany).each_with_index do |line, index|
            line = line.gsub("# =>", "-g")
            splitted= line.split('=')
            if list_number
              puts "#{index+1}. aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            else
              puts "aka g " + splitted[0].split(" ")[1].red + "=" + splitted[1]
            end
          end
        end
        puts ""
      end
    end

    # show usage
    def showUsage howmany=10, least=false
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["history"])
      value = reload_dot_file()
      #get all aliases
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        total_aliases = []
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          total_aliases.push(value.first)
        }
        count_aliases(total_aliases, howmany, least)
      end
    end

    # count aliases
    def count_aliases array, howmany, least=false
      name_array,count_array = [], []
      #find the unique value
      array.each_with_index { |value, index|
        if name_array.include?(value) == false
          name_array.push(value)
        end
      }
      #count the value
      name_array.each { |unique_value|
        count = 0
        array.each { |value|
          if (unique_value == value)
            count+=1
          end
        }
        count_array.push(count)
      }

      sorted_count_array, sorted_name_array = sort(count_array, name_array)

      #display the least used aliases
      if least == true
        if sorted_count_array.count == sorted_name_array.count
          puts ""
          sorted_name_array.last(howmany).each_with_index { |value, index|
            percent = ((sorted_count_array[sorted_name_array.last(howmany).size + index]).round(2)/array.size.round(2))*100
            str = "#{sorted_name_array.size-sorted_name_array.last(howmany).size+index+1}. #{value}"
            puts "#{str} #{showSpace(str)} #{showBar(percent)}"
          }
          puts ""
        else
          puts "Something went wrong: count_array.count = #{sorted_count_array.count}\n
          name_array.count = #{sorted_name_array.count}. Please check your .bash_history.".pretty
        end
      else
        # #print out
        if sorted_count_array.count == sorted_name_array.count
          puts ""
          sorted_name_array.first(howmany).each_with_index { |value, index|
            percent = ((sorted_count_array[index]).round(2)/array.size.round(2))*100
            str = "#{index+1}. #{value}"
            puts "#{str} #{showSpace(str)} #{showBar(percent)}"
          }
          puts ""
        else
          puts "Something went wrong: count_array.count = #{sorted_count_array.count}\n
                name_array.count = #{sorted_name_array.count}. Please check your .bash_history.".pretty
        end
      end
      puts "There's a total of #{array.size} lines in #{readYML("#{Dir.home}/.aka/.config")["history"]}."
    end

    # sort
    def sort(countarray, namearray) #highest first. decscending.
      temp = 0, temp2 = ""
      countarray.each_with_index { |count, index|
        countarray[0..countarray.size-index].each_with_index { |x, thisindex|  #always one less than total

          if index < countarray.size-1 && thisindex < countarray.size-1
            if countarray[thisindex] < countarray[thisindex+1] #if this count is less than next count
              temp = countarray[thisindex]
              countarray[thisindex] = countarray[thisindex+1]
              countarray[thisindex+1] = temp

              temp2 = namearray[thisindex]
              namearray[thisindex] = namearray[thisindex+1]
              namearray[thisindex+1] = temp2
            end
          end

        }
      }#outer loop
      return countarray, namearray
    end

    # get history file
    def get_latest_history_file
      system("history -a")
    end

    # clean up
    def cleanup
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        check = false
        while check == false
          check = true
          content_array.each_with_index { |line, index|
            if line == "" || line == "\n"
              content_array.delete_at(index)
              check = false
            end
          }
        end
        write_with_newline(content_array)
      end
    end

    ################################################
    ## Getting these babies ready for beauty contest
    ################################################

    def showSpace word
      space = ""
      val = 20 - word.size
      val = 20 if val < 0
      val.times do
        space += " "
      end
      return space
    end

    def showBar percent
      result = ""
      val = percent/100 * 50
      val = 2 if val > 1 && val < 2
      val = 1 if val.round <= 1 #for visibiity, show two bars if it's just one
      val.round.times do
        result += "+"
      end

      remaining = 50 - val.round
      remaining.times do
        result += "-".red
      end

      return result + " #{percent.round(2)}%"
    end

    def add_to_proj fullalias
      values = fullalias.split("=")
      yml = readYML("#{Dir.pwd}/.aka")
      if yml == false
        write_new_proj_aka_file fullalias
      else
        yml["proj"]["title"] = "this is title"
        yml["proj"]["summary"] = "this is summary"
        yml["proj"]["aka"][values.first] = values[1]
        writeYML("#{Dir.pwd}/.aka", yml)
      end
    end

    def write_new_proj_aka_file fullalias
      values = fullalias.split("=")

      theyml = {"proj" => {
                  "title" => "",
                   "summary" => "",
                   "aliases" => {
                        "firstvalue" => ""
                              }}}

      writeYML("#{Dir.pwd}/.aka", theyml)
    end

    def createShortcut(proj)
      answer = ""
      proj["shortcuts"].to_a.each_with_index do |each,index|
          answer += "#{each["name"]}
                      - #{each["command"]}
                      ".pretty
          answer += "\n"
      end
      return answer
    end


    def list_all_groups_in_proj_aka
      str = 'proj.aka'
      group_array = []
      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == 'alias'

            answer = value[1].split("=") #contains the alias
            group_name = line.scan(/# => ([a-zA-z]*)/).first if line.scan(/# => ([a-zA-z]*)/)
            if group_name != nil
              group_array.push(group_name)
            end
          end
        }

        puts group_array.uniq

        puts ""
        puts "A total of #{group_array.uniq.count} groups from #{Dir.pwd}/proj.aka"
        puts ""

      end
    end



    def list_all_groups
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["dotfile"])
      group_array = []
      if content=File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array= content.split("\n")
        content_array.each_with_index { |line, index|
          value = line.split(" ")
          if value.length > 1 && value.first == 'alias'

            answer = value[1].split("=") #contains the alias
            group_name = line.scan(/# => ([a-zA-z]*)/).first if line.scan(/# => ([a-zA-z]*)/)
            if group_name != nil
              group_array.push(group_name)
            end
          end
        }

        puts group_array.uniq

        puts ""
        puts "A total of #{group_array.uniq.count} groups from #{readYML("#{Dir.home}/.aka/.config")["dotfile"]}"
        puts ""

      end
    end


    def print_title(with_these)
      puts ""
      puts "*** #{with_these} ***"
      puts ""
    end

    def add_last_command name
      command= find_last_command()
      return str = name + "=" + "#{command}"
    end

    def find_last_command
      str = is_config_file_present?(readYML("#{Dir.home}/.aka/.config")["history"])
      #i think if you do history -w, you can retrieve the latest command
      if content = File.open(str).read
        count=0
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        return  content_array[content_array.count - 1]
      end
    end

    def parseARGS str
      array =  str.split(" ")
      array.each_with_index do |line, value|
        array[value] = line.gsub('#{pwd}', Shellwords.escape(Dir.pwd))
      end
      return array.join(" ")
    end

    def showConfig
      thing = YAML.load_file("#{Dir.home}/.aka/.config")
      puts ""
      thing.each do |company,details|
        puts "#{company} -> " + "#{details}".red
      end
    end

    def setZSHRC
      setPath("#{Dir.home}/.zshrc","dotfile")
      setPath("#{Dir.home}/.zsh_history","history")
      setPath("/etc/zprofile","profile")
    end

    def setBASHRC
      setPath("#{Dir.home}/.bashrc","dotfile")
      setPath("#{Dir.home}/.bash_history","history")
      setPath("/etc/profile","profile")
    end

    def setBASH
      setPath("#{Dir.home}/.bash_profile","dotfile")
      setPath("#{Dir.home}/.bash_history","history")
      setPath("/etc/profile","profile")
    end

    def setZSHRC2 #ryan - set the right dotfile and profile
      setPath("#{Dir.home}/.zshrc","dotfile")
      setPath("#{Dir.home}/.zsh_history","history")
      setPath("#{Dir.home}/.zshrc","profile")
      setPath("#{Dir.home}/.aka","home")
    end

    def setBASHRC2 #ryan - set the right dotfile and profile
      setPath("#{Dir.home}/.bashrc","dotfile")
      setPath("#{Dir.home}/.bash_history","history")
      setPath("#{Dir.home}/.bashrc","profile")
      setPath("#{Dir.home}/.aka","home")
    end

    def setBASH2 #ryan - set the right dotfile and profile
      setPath("#{Dir.home}/.bash_profile","dotfile")
      setPath("#{Dir.home}/.bash_history","history")
      setPath("/etc/profile","profile")
      setPath("#{Dir.home}/.aka","home")
    end

    def setPROFILE
      setPath("#{Dir.home}/.profile","dotfile")
      setPath("#{Dir.home}/.bash_history","history")
      setPath("/etc/profile","profile")
      setPath("#{Dir.home}/.aka","home")
    end

    # def get_password
    #   ask("Enter Password: ", :echo => false)
    # end

    def isOhMyZsh
      readYML("#{Dir.home}/.aka/.config")["dotfile"] == "#{Dir.home}/.zshrc" ? true : false
    end


    def print_error_statement
      puts "Error: ".red + "The proj.aka is missing. Please run [aka export <name_of_group>] to generate proj.aka file"
    end

    def print_helpful_statement total_aliases
      puts "\nA total of  #{total_aliases} aliases in this project #{Dir.pwd}"
      puts "\nUse 'aka -h' to see all the useful commands."
    end

    def repeated_system_call array
      array.each do |line|
        line.gsub!("\'", "\"") #need to replace ' with "
        line = line + " -n" #do not reload :)
        system(line)
      end
    end

    def print_all_helpful_statement
      puts "A total of #{count()} aliases, #{count_groups} groups, #{count_export} exports and #{count_function} functions from #{readYML("#{Dir.home}/.aka/.config")["dotfile"]}"
      puts "\nUse 'aka -h' to see all the useful commands.\n\n"
    end



    def print_the_aliases_return_array2 content_array, name
      array = []
      content_array.each_with_index { |line, index|
        testline = line
        line = line.gsub("# =>", "-g")
        value = testline.split(" ")
        containsCommand = line.split('=') #containsCommand[1]
        if value.length > 1 && value.first == "alias"
          answer = value[1].split("=") #contains the alias
          group_name = testline.scan(/# => ([a-zA-z]*)/).first if testline.scan(/# => ([a-zA-z]*)/)
          if group_name != nil && group_name.first == name
            array.push(testline)
          end
        end
      }
      return array
    end

    def print_the_aliases_return_array content_array
      array = []
      content_array.each_with_index { |line, index|
        testline = line
        line = line.gsub("# =>", "-g")
        value = testline.split(" ")
        containsCommand = line.split('=') #containsCommand[1]
        if value.length > 1 && value.first == "alias"
          answer = value[1].split("=") #contains the alias
          group_name = testline.scan(/# => ([a-zA-z]*)/).first if testline.scan(/# => ([a-zA-z]*)/)
          containsCommand[1].slice!(0) &&  containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
          array.push("aka g " + "#{answer.first}" + "=#{containsCommand[1]}")
        end
      }
      return array
    end


    def print_the_aliases2 content_array, name
      answer_count= 0
      content_array.each_with_index { |line, index|
        testline = line
        line = line.gsub("# =>", "-g")
        value = testline.split(" ")
        containsCommand = line.split('=') #containsCommand[1]

        if value.length > 1 && value.first == "alias"
          answer = value[1].split("=") #contains the alias
          group_name = testline.scan(/# => ([a-zA-z]*)/).first if testline.scan(/# => ([a-zA-z]*)/)
          if group_name != nil && group_name.first == name
            containsCommand[1].slice!(0) &&  containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
            puts "aka g " + "#{answer.first}".red + "=#{containsCommand[1]}"
            answer_count += 1
          end
        end
      }
      return answer_count
    end


    def print_the_aliases content_array
      answer_count= 0
      content_array.each_with_index { |line, index|
        # testLine = line
        line = line.gsub("# =>", "-g")
        value = line.split(" ")
        containsCommand = line.split('=') #containsCommand[1]
        answer = value[1].split("=") #contains the alias
        group_name = line.scan(/# => ([a-zA-z]*)/).first if line.scan(/# => ([a-zA-z]*)/)

        if value.length > 1 && value.first == 'alias'
            containsCommand[1].slice!(0) &&  containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
            puts "aka g " + "#{answer.first}".red + "=#{containsCommand[1]}"
          answer_count+= 1
        end
      }
      return answer_count
    end

  end #that's all
end #last end

class String

  def pretty
    self.gsub("\s\t\r\f", ' ').squeeze(' ')
  end

  def is_i?
    !!(self =~ /\A[-+]?[0-9]+\z/)
  end

  def colorize(color_code)
     "\e[#{color_code}m#{self}\e[0m"
   end

   def red
     colorize(31)
   end

   def green
     colorize(32)
   end

   def yellow
     colorize(33)
   end

   def blue
     colorize(34)
   end

   def pink
     colorize(35)
   end

   def light_blue
     colorize(36)
   end
end

__END__
