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
      write_with_array_into_withprint(new_proj_aka, array)
    else
      if File.exist?('proj.aka')
        if force
          write_with_array_into_withprint('proj.aka', array)
        else
          exist_statement("proj.aka already exists. Use -f to recreate a proj.aka")
        end
      else
        FileUtils.touch('proj.aka')
        write_with_array_into_withprint('proj.aka', array)
      end
    end
  end

  def self.get_all_aliases_from_proj_aka str="proj.aka"
    array = []
    if content = File.open(str).read
      content_array = product_content_array(content)
      array = print_the_aliases_return_array(content_array)
    end
    return array
  end

  def self.set_path(path, value)
    data = read_YML("#{CONFIG_PATH}")
    if data.has_key?(value) == true
      old_path = data[value]
      data[value] = path
      write_YML("#{CONFIG_PATH}", data)
      puts "#{value} -> #{path}"
    else
      error_statement("--#{value} does not exist in #{CONFIG_PATH} ")
    end
  end

  def self.reload_with_source
    system "source #{read_YML("#{CONFIG_PATH}")["dotfile"]}"
  end

  def self.read_YML path
    if File.exist? path
      return YAML.load_file(path)
    else
      error_statement("#{CONFIG_PATH} does not exist. Type `aka setup` to setup the config file")
    end
  end

  def self.write_YML path, theyml
    File.open(path, 'w') {|f| f.write theyml.to_yaml } #Store
  end

  def self.write_with_array_into_withprint path, array
    File.open(path, 'w') { |file|
      file.write("#generated with https://rubygems.org/gems/aka3")
      file.write("\n\n")

      array.each do |line|
        file.write(line)
        file.write("\n")
      end
    }
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
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
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

  def self.split fulldomain
    username = fulldomain.split("@").first
    domain = fulldomain.split("@")[1].split(":").first
    port = fulldomain.split("@")[1].split(":")[1]
    return [username, domain, port]
  end

  def self.add_a_function input, name_of_group
    if input && search_alias_return_alias_tokens(input).first == false && not_empty_alias(input) == false
      array = input.split("=")
      group_name = "# => #{name_of_group}"

      full_command = "function #{array.first}(){ #{array[1]} } #{group_name}".gsub("\n","") #remove new line in command

      # full_command = "alias #{array.first}='#{array[1]}' #{group_name}".gsub("\n","") #remove new line in command
      print_out_command = "aka g #{array.first}='#{array[1]}'"
      str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
      File.open(str, 'a') { |file| file.write("\n" +full_command) }
      create_statement "#{print_out_command} " + "in #{name_of_group} group."
      return true
    else
      puts "The alias is already present. Use 'aka -h' to see all the useful commands."
      return false
    end
  end

  def self.add_with_group input, name_of_group
    if input && search_alias_return_alias_tokens(input).first == false && not_empty_alias(input) == false
      array = input.split("=")
      group_name = "# => #{name_of_group}"
      full_command = "alias #{array.first}='#{array[1]}' #{group_name}".gsub("\n","") #remove new line in command
      print_out_command = "aka g #{array.first}='#{array[1]}'"
      str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
      File.open(str, 'a') { |file| file.write("\n" +full_command) }
      create_statement "#{print_out_command} " + "in #{name_of_group} group."
      return true
    else
      puts "The alias is already present. Use 'aka -h' to see all the useful commands."
      return false
    end
  end

  def self.add input
    if input && search_alias_return_alias_tokens(input).first == false && not_empty_alias(input) == false
      array = input.split("=")
      full_command = "alias #{array.first}='#{array[1]}'".gsub("\n","") #remove new line in command
      print_out_command = "aka g #{array.first}='#{array[1]}'"
      str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
      File.open(str, 'a') { |file| file.write("\n" +full_command) }
      create_statement "#{print_out_command}"
      return true
    else
      puts "The alias is already present. Use 'aka -h' to see all the useful commands."
      return false
    end
  end

  def self.not_empty_alias input
    array = input.split("=")
    return true if array.count < 2
    return array[1].strip == ""
  end

  def self.search_alias_with_group_name name
    print_title("System Alias")
    group_count = 0
    if name == "group"
      name = "default"
      str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
      if content = File.open(str).read
        content_array = product_content_array(content)
        group_count = print_the_aliases(content_array)
        if group_count == 0
          puts "No alias found in default group"
        else
          exist_statement("A total of #{group_count} aliases in default group.")
        end
      end
    else

      str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
      if content = File.open(str).read
        content_array = product_content_array(content)
        group_count = print_the_aliases2(content_array, name)
      end

      if group_count == 0
        puts "No alias found in #{name} group"
      else
        exist_statement("A total of #{group_count} aliases in #{name} group.")
      end
    end
  end

  def self.change_alias_group_name_with input, new_group_name
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content_array = product_content_array(content)
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
      error_statement "There is no input"
    end
  end

  def self.export_group_aliases name
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    results = []
    if content = File.open(str).read
      content_array = product_content_array(content)
      results = print_the_aliases_return_array2(content_array, name)
    end
    return results
  end

  def self.search_alias_return_alias_tokens argument
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content_array = product_content_array(content)
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

  def self.search_alias_return_alias_tokens_with_group argument
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content_array = product_content_array(content)
      content_array.each_with_index { |line, index|
        value = line.split(" ")
        if value.length > 1 && value.first == "alias"
          # templine = line.gsub("# =>", "-g")
          templine = line.split("# =>").first
          containsCommand = templine.split('=') #containsCommand[1]
          group_name = get_group_name(line)
          answer = value[1].split("=") #contains the alias
          if found?(answer.first, argument.split("=").first, templine) == true
            this_alias = answer.first
            answer.slice!(0) #rmove the first
            containsCommand[1].strip!
            containsCommand[1].slice!(0) &&  containsCommand[1].slice!(containsCommand[1].length-1) if containsCommand[1] != nil && containsCommand[1][0] == "'" && containsCommand[1][containsCommand[1].length-1] == "'"
            return [true, this_alias, containsCommand[1], group_name]
          end
        end
      }
    else
      puts "#{@pwd} cannot be found.".red
      return [false, nil, nil, nil]
    end
    return [false, nil, nil, nil]
  end

  def self.remove input
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content=File.open(str).read
      content_array = product_content_array(content)
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

  def self.remove_autosource
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content=File.open(str).read
      content_array = product_content_array(content)
      content_array.each_with_index { |line, index|
        if line == "source \"/home/ryan/.aka/autosource\""
          content_array.delete_at(index) && write_with_newline(content_array)
          puts "Removed: ".red + "source \"/home/ryan/.aka/autosource\""
          return true
        end
      }
    else
      error_statement("autosource cannot be found in dotfile.")
      return false
    end
  end

  def self.history
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["history"])
    if content = File.open(str).read
      puts ".bash_history is available"
      count=0
      content_array = product_content_array(content)
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
      return true
    else
      return false
    end
  end

  def self.edit_alias_command newcommand, this_alias
    Aka.remove(this_alias) #remove that alias

    edit_statement "aka g #{this_alias}='#{newcommand}'"
    return append("alias " + this_alias + "='" + newcommand + "'", read_YML("#{CONFIG_PATH}")["dotfile"] )
  end

  def self.edit_alias_command_with_group newcommand, this_alias, group
    if !group.nil? || !group.empty?
      edit_statement("aka g #{this_alias}='#{newcommand}' -g #{group}")
      return append("alias " + this_alias + "='" + newcommand + "' # => " + group, read_YML("#{CONFIG_PATH}")["dotfile"] )
    else
      edit_statement("aka g #{this_alias}='#{newcommand}'")
      return append("alias " + this_alias + "='" + newcommand + "'", read_YML("#{CONFIG_PATH}")["dotfile"] )
    end
  end

  def self.edit_alias_name newalias, thiscommand
    Aka.remove(thiscommand) #remove that alias
    edit_statement("aka g #{newalias}='#{thiscommand}'")
    return append("alias " + newalias + "='" + thiscommand + "'", read_YML("#{CONFIG_PATH}")["dotfile"] )
  end

  def self.edit_alias_name_with_group newalias, thiscommand, group
    if !group.nil? || !group.empty?
      edit_statement "aka g #{newalias}='#{thiscommand}' -g #{group}"
      return append("alias " + newalias + "='" + thiscommand + "' # => " + group, read_YML("#{CONFIG_PATH}")["dotfile"] )
    else
      edit_statement "aka g #{newalias}='#{thiscommand}'"
      return append("alias " + newalias + "=" + thiscommand, read_YML("#{CONFIG_PATH}")["dotfile"] )
    end
  end

  def self.count_groups
    group_counts = 0
    group_array = []
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content=File.open(str).read
      content_array = product_content_array(content)
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
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content=File.open(str).read
      content_array = product_content_array(content)
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
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content=File.open(str).read
      content_array = product_content_array(content)
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
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content=File.open(str).read
      content_array = product_content_array(content)
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

  def self.read location
    answer = File.exist?(location)
    answer == true && content = File.open(location).read ? content : ""
  end

  def self.is_config_file_present? str
    # path =  "#{BASH_PROFILE_PATH}"
    path = "blah"
    if str == ""
      error_statement("Type `aka init --dotfile #{path}` to set the path to your dotfile. \nReplace .bash_profile with .bashrc or .zshrc if you are not using bash.")
      exit
    end

    if !File.exist?(str)
      error_statement("Type `aka init --dotfile #{path}` to set the path of your dotfile. \nReplace .bash_profile with .bashrc or .zshrc if you are not using bash.")
      exit
    end
    return str
  end

  def self.show_last(list_number=false,howmany=10, showGroup)
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content_array = product_content_array(content)
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

  def self.show_usage howmany=10, least=false
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["history"])
    value = reload_dot_file
    #get all aliases
    if content = File.open(str).read
      content_array = product_content_array(content)
      total_aliases = []
      content_array.each_with_index { |line, index|
        value = line.split(" ")
        total_aliases.push(value.first)
      }
      count_aliases(total_aliases, howmany, least)
    end
  end

  def self.count_aliases array, howmany, least=false
    name_array,count_array = [], []
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
          puts "#{str} #{show_space(str)} #{show_bar(percent)}"
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
          puts "#{str} #{show_space(str)} #{show_bar(percent)}"
        }
        puts ""
      else
        puts "Something went wrong: count_array.count = #{sorted_count_array.count}\n
              name_array.count = #{sorted_name_array.count}. Please check your .bash_history.".pretty
      end
    end
    puts "There's a total of #{array.size} lines in #{read_YML("#{CONFIG_PATH}")["history"]}."
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
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    if content = File.open(str).read
      content_array = product_content_array(content)
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

  def self.list_all_groups_in_proj_aka
    Aka.print_title("Project Groups")
    str = 'proj.aka'
    group_array = []
    if content=File.open(str).read
      content_array = product_content_array(content)
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
    Aka.print_title("System Groups")
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["dotfile"])
    group_array = []
    if content=File.open(str).read
      content_array = product_content_array(content)
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
      puts "A total of #{group_array.uniq.count} groups from #{read_YML("#{CONFIG_PATH}")["dotfile"]}"
      puts ""

    end
  end

  def self.add_last_command name
    command = ""
    str = is_config_file_present?(read_YML("#{CONFIG_PATH}")["history"])
    #i think if you do history -w, you can retrieve the latest command
    if content = File.open(str).read
      count=0
      content_array = product_content_array(content)
      command =  content_array[content_array.count - 1]
    end
    return str = name + "=" + "#{command}"
  end

  def self.parse_ARGS str
    array =  str.split(" ")
    array.each_with_index do |line, value|
      array[value] = line.gsub('#{pwd}', Shellwords.escape(Dir.pwd))
    end
    return array.join(" ")
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
