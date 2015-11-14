require 'aka/constants'

module Aka

  def self.product_content_array(content)
    content.gsub!(/\r\n?/, "\n")
    return content_array = content.split("\n")
  end

  def self.import(the_name)
    if the_name == ""
      array = get_all_aliases_from_proj_aka
      repeated_system_call(array)
    else
      array = get_all_aliases_from_proj_aka(the_name)
      repeated_system_call(array)
    end
  end

  def self.export(arg, the_name, force)
    array = export_group_aliases(arg)
    if the_name != "load"
      new_proj_aka = "#{the_name}"+".aka"
      FileUtils.touch(new_proj_aka)
      write_with_array_into(new_proj_aka, array)
    else
      if File.exist?('proj.aka')
        if force
          write_with_array_into('proj.aka', array)
        else
          exist_statement("proj.aka already exists. Use -f to recreate a proj.aka")
        end
      else
        FileUtils.touch('proj.aka')
        write_with_array_into('proj.aka', array)
      end
    end
  end

  def self.get_all_aliases_from_proj_aka str="proj.aka"
    array = []
    if content = File.open(str).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")
      array = print_the_aliases_return_array(content_array)
    end
    return array
  end

  def self.setPath(path, value)
    data = readYML("#{CONFIG_PATH}")
    if data.has_key?(value) == TRUE
      old_path = data[value]
      data[value] = path
      writeYML("#{CONFIG_PATH}", data)
      puts "#{value} -> #{path}"
    else
      error_statement("--#{value} does not exist in #{CONFIG_PATH} ")
    end
  end

  def self.reload_with_source
    system "source #{readYML("#{CONFIG_PATH}")["dotfile"]}"
  end

  def self.readYML path
    if File.exists? path
      return YAML.load_file(path)
    else
      error_statement("#{CONFIG_PATH} does not exist. Type `aka setup` to setup the config file")
    end
  end

  def self.writeYML path, theyml
    File.open(path, 'w') {|f| f.write theyml.to_yaml } #Store
  end

  def self.write_with_array_into path, array
    File.open(path, 'w') { |file|
      array.each do |line|
        file.write(line)
        file.write("\n")
      end
    }
  end

  def self.write_with_newline array
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
    File.open(str, 'w') { |file|
      array.each do |line|
        file.write(line + "\n")
      end
    }
  end

  def self.write str, path
    File.open(path, 'w') { |file| file.write(str) }
  end

  def self.append str, path
    File.open(path, 'a') { |file| file.write(str) }
  end

  # def self.reload_dot_file
  #   isOhMyZsh == TRUE ? system("exec zsh") : system("kill -SIGUSR1 #{Process.ppid}")
  # end
  #
  # def self.unalias_the value
  #   if isOhMyZsh == TRUE
  #     system("exec zsh")
  #   else
  #     system "echo '#{value}' > ~/sigusr1-args;"
  #     system "kill -SIGUSR2 #{Process.ppid}"
  #   end
  # end

  def self.split fulldomain
    username = fulldomain.split("@").first
    domain = fulldomain.split("@")[1].split(":").first
    port = fulldomain.split("@")[1].split(":")[1]
    return [username, domain, port]
  end

  def self.add_with_group input, name_of_group
    if input && search_alias_return_alias_tokens(input).first == FALSE && not_empty_alias(input) == FALSE
      array = input.split("=")
      group_name = "# => #{name_of_group}"
      full_command = "alias #{array.first}='#{array[1]}' #{group_name}".gsub("\n","") #remove new line in command
      print_out_command = "aka g #{array.first}='#{array[1]}'"
      str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
      File.open(str, 'a') { |file| file.write("\n" +full_command) }
      puts "Created: ".green +  "#{print_out_command} " + "in #{name_of_group} group."
      return TRUE
    else
      puts "The alias is already present. Use 'aka -h' to see all the useful commands."
      return FALSE
    end
  end

  def self.add input
    if input && search_alias_return_alias_tokens(input).first == FALSE && not_empty_alias(input) == FALSE
      array = input.split("=")
      full_command = "alias #{array.first}='#{array[1]}'".gsub("\n","") #remove new line in command
      print_out_command = "aka g #{array.first}='#{array[1]}'"
      str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
      File.open(str, 'a') { |file| file.write("\n" +full_command) }
      puts "Created: ".green +  "#{print_out_command}"
      return TRUE
    else
      puts "The alias is already present. Use 'aka -h' to see all the useful commands."
      return FALSE
    end
  end

  def self.not_empty_alias input
    array = input.split("=")
    return TRUE if array.count < 2
    return array[1].strip == ""
  end

  def self.search_alias_with_group_name name
    print_title("System Alias")
    group_count = 0
    if name == "group"
      name = "default"
      str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        group_count = print_the_aliases(content_array)

        if group_count == 0
          puts "No alias found in default group"
        else
          puts ""
          exist_statement("A total of #{group_count} aliases in default group.")
          puts ""
        end
      end
    else

      str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
      if content = File.open(str).read
        content.gsub!(/\r\n?/, "\n")
        content_array = content.split("\n")
        group_count = print_the_aliases2(content_array, name)
      end

      if group_count == 0
        puts "No alias found in #{name} group"
      else
        puts ""
        exist_statement("A total of #{group_count} aliases in #{name} group.")
        puts ""
      end
    end
  end

  def self.change_alias_group_name_with input, new_group_name
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")

      content_array.each_with_index { |line, index|
        value = line.split(" ")
        if value.length > 1 && value.first == "alias"
          aliasWithoutGroup = line.split("# =>").first.strip
          answer = value[1].split("=") #contains the alias
          if input == answer.first
            alias_n_command = aliasWithoutGroup.split(" ").drop(1).join(" ")
            containsCommand = alias_n_command.split('=') #containsCommand[1]
            containsCommand[1].slice!(0) && containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
            alias_n_command = answer.first+"="+containsCommand[1]
            remove(answer.first)
            result = add_with_group(alias_n_command,new_group_name)
            reload_dot_file if result
          end
        end
      }
    else
      puts "#{@pwd} cannot be found.".red
    end
  end

  def self.get_group_name input
    if input
      if input.include? "# =>"
        return input.split("# =>").last.strip
      else
        return nil
      end
    else
      puts "There is no input"
    end
  end

  def self.export_group_aliases name
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
    results = []
    if content = File.open(str).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")
      results = print_the_aliases_return_array2(content_array, name)
    end
    return results
  end

  def self.search_alias_return_alias_tokens argument
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")

      content_array.each_with_index { |line, index|
        line = line.gsub("# =>", "-g")
        value = line.split(" ")
        containsCommand = line.split('=') #containsCommand[1]
        if value.length > 1 && value.first == "alias"
          answer = value[1].split("=") #contains the alias
          if found?(answer.first, argument.split("=").first, line) == TRUE
            this_alias = answer.first
            answer.slice!(0) #rmove the first
            containsCommand[1].slice!(0) &&  containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
            return [TRUE, this_alias, containsCommand[1]]
          end
        end
      }
    else
      puts "#{@pwd} cannot be found.".red
      return [FALSE, nil, nil]
    end
    return [FALSE, nil, nil]

  end

  def self.search_alias_return_alias_tokens_with_group argument
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")

      content_array.each_with_index { |line, index|
        value = line.split(" ")
        if value.length > 1 && value.first == "alias"
          # templine = line.gsub("# =>", "-g")
          templine = line.split("# =>").first
          containsCommand = templine.split('=') #containsCommand[1]
          group_name = get_group_name(line)
          answer = value[1].split("=") #contains the alias
          if found?(answer.first, argument.split("=").first, templine) == TRUE
            this_alias = answer.first
            answer.slice!(0) #rmove the first
            containsCommand[1].strip!
            containsCommand[1].slice!(0) &&  containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
            return [TRUE, this_alias, containsCommand[1], group_name]
          end
        end
      }
    else
      puts "#{@pwd} cannot be found.".red
      return [FALSE, nil, nil, nil]
    end
    return [FALSE, nil, nil, nil]
  end

  def self.remove input
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
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
            return TRUE
          end
        end
      }

      puts "#{input} cannot be found.".red
    else
      puts "#{@pwd} cannot be found.".red
      return FALSE
    end
  end

  def self.remove_autosource
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
    if content=File.open(str).read
      content.gsub!(/\r\n?/, "\n")
      content_array= content.split("\n")
      content_array.each_with_index { |line, index|
        if line == "source \"/home/ryan/.aka/autosource\""
          content_array.delete_at(index) && write_with_newline(content_array)
          puts "Removed: ".red + "source \"/home/ryan/.aka/autosource\""
          return TRUE
        end
      }
    else
      error_statement("autosource cannot be found in dotfile.")
      return FALSE
    end
  end

  def self.history
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["history"])
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
      error_statement(".bash_history is not available")
    end
  end

  def self.found? answer, argument, line
    if answer == argument
      exist_statement(" aka g #{argument}=#{line.split('=')[1]}")
      return TRUE
    else
      return FALSE
    end
  end

  def self.edit_alias_command newcommand, this_alias
    edit_statement "aka g #{this_alias}='#{newcommand}'"
    return append("alias " + this_alias + "='" + newcommand + "'", readYML("#{CONFIG_PATH}")["dotfile"] )
  end

  def self.edit_alias_command_with_group newcommand, this_alias, group
    if !group.nil? || !group.empty?
      edit_statement("aka g #{this_alias}='#{newcommand}' -g #{group}")
      # puts "Edited:  ".yellow + "aka g #{this_alias}='#{newcommand}' -g #{group}"
      return append("alias " + this_alias + "='" + newcommand + "' # => " + group, readYML("#{CONFIG_PATH}")["dotfile"] )
    else
      edit_statement("aka g #{this_alias}='#{newcommand}'")
      # puts "Edited:  ".yellow + "aka g #{this_alias}='#{newcommand}'"
      return append("alias " + this_alias + "='" + newcommand + "'", readYML("#{CONFIG_PATH}")["dotfile"] )
    end
  end

  def self.edit_alias_name newalias, thiscommand
    edit_statement("aka g #{newalias}='#{thiscommand}'")
    # puts "Edited:  ". yellow + "aka g #{newalias}='#{thiscommand}'"
    return append("alias " + newalias + "='" + thiscommand + "'", readYML("#{CONFIG_PATH}")["dotfile"] )
  end

  def self.edit_alias_name_with_group newalias, thiscommand, group
    if !group.nil? || !group.empty?
      edit_statement "aka g #{newalias}='#{thiscommand}' -g #{group}"
      return append("alias " + newalias + "='" + thiscommand + "' # => " + group, readYML("#{CONFIG_PATH}")["dotfile"] )
    else
      edit_statement "aka g #{newalias}='#{thiscommand}'"
      return append("alias " + newalias + "=" + thiscommand, readYML("#{CONFIG_PATH}")["dotfile"] )
    end
  end

  def self.count_groups
    group_counts = 0
    group_array = []
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
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

  def self.count_function
    function_count = 0
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
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

  def self.count_export
    export_count = 0
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
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

  def self.count
    alias_count = 0
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
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
    if File.exist?("#{CONFIG_PATH}")
      out_file = File.new("#{CONFIG_PATH}/autosource", "w")
      out_file.puts("export HISTSIZE=10000")
      out_file.puts("sigusr2() { unalias $1;}")
      out_file.puts("sigusr1() { source #{readYML("#{CONFIG_PATH}")["dotfile"]}; history -a; echo 'reloaded dot file'; }")
      out_file.puts("trap sigusr1 SIGUSR1")
      out_file.puts("trap 'sigusr2 $(cat ~/sigusr1-args)' SIGUSR2")
      out_file.close
      autosource = "\nsource \"#{CONFIG_PATH}/autosource\""
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
      FileUtils::mkdir_p("#{CONFIG_PATH}")
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

  def self.read location
    answer = File.exist?(location)
    answer == TRUE && content = File.open(location).read ? content : ""
  end

  def self.is_config_file_present? str
    path =  "#{BASH_PROFILE_PATH}"
    if str == ""
      error_statement("Type `aka init --dotfile #{path}` to set the path to your dotfile. \nReplace .bash_profile with .bashrc or .zshrc if you are not using bash.")
      exit
    end

    if !File.exists?(str)
      error_statement("Type `aka init --dotfile #{path}` to set the path of your dotfile. \nReplace .bash_profile with .bashrc or .zshrc if you are not using bash.")
      exit
    end
    return str
  end

  def self.showlast(list_number=FALSE,howmany=10, showGroup)
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])

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

  def self.showUsage howmany=10, least=FALSE
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["history"])
    value = reload_dot_file
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

  def self.count_aliases array, howmany, least=FALSE
    name_array,count_array = [], []
    array.each_with_index { |value, index|
      if name_array.include?(value) == FALSE
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
    if least == TRUE
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
    puts "There's a total of #{array.size} lines in #{readYML("#{CONFIG_PATH}")["history"]}."
  end

  def self.sort(countarray, namearray) #highest first. decscending.
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

  def self.cleanup
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")
      check = FALSE
      while check == FALSE
        check = TRUE
        content_array.each_with_index { |line, index|
          if line == "" || line == "\n"
            content_array.delete_at(index)
            check = FALSE
          end
        }
      end
      write_with_newline(content_array)
    end
  end

  ################################################
  ## Getting these babies ready for beauty contest
  ################################################

  def self.showSpace word
    space = ""
    val = 20 - word.size
    val = 20 if val < 0
    val.times do
      space += " "
    end
    return space
  end

  def self.showBar percent
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

  def self.list_all_groups_in_proj_aka
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

  def self.list_all_groups
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["dotfile"])
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
      puts "A total of #{group_array.uniq.count} groups from #{readYML("#{CONFIG_PATH}")["dotfile"]}"
      puts ""

    end
  end

  def self.add_last_command name
    command = ""
    str = is_config_file_present?(readYML("#{CONFIG_PATH}")["history"])
    #i think if you do history -w, you can retrieve the latest command
    if content = File.open(str).read
      count=0
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")
      command =  content_array[content_array.count - 1]
    end
    return str = name + "=" + "#{command}"
  end

  def self.parseARGS str
    array =  str.split(" ")
    array.each_with_index do |line, value|
      array[value] = line.gsub('#{pwd}', Shellwords.escape(Dir.pwd))
    end
    return array.join(" ")
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
    readYML("#{CONFIG_PATH}")["dotfile"] == "#{ZSHRC_PATH}" ? TRUE : FALSE
  end

  def self.repeated_system_call array
    array.each do |line|
      line.gsub!("\'", "\"") #need to replace ' with "
      line = line + " -n" #do not reload :)
      system(line)
    end
  end

  def self.print_the_aliases_return_array2 content_array, name
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

  def self.print_the_aliases_return_array content_array
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

  def self.print_the_aliases2 content_array, name
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

  def self.print_the_aliases content_array
    answer_count= 0
    content_array.each_with_index { |line, index|
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
end

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
