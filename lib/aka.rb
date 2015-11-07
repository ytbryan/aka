require 'aka/version' #required for the test to work
require 'aka/constants'
require 'aka/helpers'
require 'yaml'
require 'thor'
require 'shellwords'
require 'fileutils'

module Aka
  class Base < Thor
    check_unknown_options!
    package_name "aka"
    default_task :list
    map "g" => :generate,
        "d" => :destroy,
        "f" => :find,
        "u" => :usage,
        "l" => :list,
        "e" => :edit,
        "c" => :clean,
        "h" => :help,
        "v" => :version


    desc "test", "test and show that this won't work"
    def test
      # Something.boo
    end

    # desc :import, "import project alias into your system alias"
    # method_option :all, :type => :boolean, :aliases => '-a', :desc => 'import all .aka'
    # def import the_name=""
    #   if the_name == ""
    #     array = get_all_aliases_from_proj_aka
    #     repeated_system_call(array)
    #   else
    #     array = get_all_aliases_from_proj_aka(the_name)
    #     repeated_system_call(array)
    #   end
    # end

    #
    # Groups
    #
    desc :groups, "list all the groups"
    def groups
      Aka.print_title("System Groups")
      Aka.list_all_groups
    end

    #
    # Where is your dotfile
    # aka where
    desc :where, "locate your dotfile"
    def where
      puts Aka.readYML("#{CONFIG_PATH}")["dotfile"]
    end

    #
    # Export
    #
    # desc :export, "export system alias into project alias"
    # method_option :force, :type => :boolean, :aliases => '-f', :desc => ''
    # method_option :name, :type => :string, :aliases => '-n', :desc => ''
    # def export the_name
    #   array = export_group_aliases(the_name)
    #   if options.name?
    #     new_proj_aka = "#{options.name}"+".aka"
    #     FileUtils.touch(new_proj_aka)
    #     write_with_array_into(new_proj_aka, array)
    #   else
    #     if File.exist?('proj.aka')
    #       if options.force?
    #         write_with_array_into('proj.aka', array)
    #       else
    #         exist_statement("proj.aka already exists. Use -f to recreate a proj.aka")
    #       end
    #     else
    #       FileUtils.touch('proj.aka')
    #       write_with_array_into('proj.aka', array)
    #     end
    #   end
    # end

    #################
    # PROJ
    #################
    desc :proj, "list the project alias (short alias: p)"
    method_option :group, :type => :boolean, :aliases => '-g'
    method_option :load, :type => :string, :aliases => '-i' #export
    method_option :save, :type => :string, :aliases => '-e'
    method_option :force, :type => :boolean, :aliases => '-f'

    def proj
      if options.load
        Aka.export(options.load, options.force)
      elsif options.save
        Aka.import(options.save)
      else
        if options.group? && File.exist?('proj.aka')
          Aka.print_title("Project Groups")
          Aka.list_all_groups_in_proj_aka
        elsif options.group? && !File.exist?('proj.aka')
          Aka.error_statement("The proj.aka is missing. Please run [aka export <name_of_group>] to generate proj.aka file")
        else
          Aka.print_title("Project Alias")
          if File.exist?('proj.aka')
            if content = File.open('proj.aka').read
              content_array = Aka.product_content_array(content)
              answer_count = Aka.print_the_aliases(content_array)
              Aka.print_helpful_statement(answer_count)
            end
          else
            Aka.error_statement("The proj.aka is missing. Please run [aka export <name_of_group>] to generate proj.aka file")
          end
        end
      end #end of when

    end

    #################
    # GENERATE
    #################
    desc :generate, "generate an alias (short alias: g)"
    method_option :last, :type => :boolean, :aliases => '-l', :desc => ''
    method_option :group, :type => :string, :aliases => '-g', :desc => '', :default => 'default'
    method_option :no, :type => :boolean, :aliases => '-n', :desc => '--no means do not reload'
    method_option :empty, :type => :boolean, :aliases => '-e', :desc => 'do not print anything'
    def generate args
      result = false
      if options.last? && args
        result = Aka.add_with_group(Aka.add_last_command(Aka.parseARGS(args)))
      else
        result = Aka.add_with_group(Aka.parseARGS(args), options.group)
      end
      Aka.reload_dot_file if result == true && !options.no
    end

    #
    # DESTROY
    #
    desc :destroy, "destroy an alias (short alias: d)"
    method_options :force => :boolean
    method_option :no, :type => :boolean, :aliases => '-n', :desc => '--no means do not reload'
    def destroy(*args)
      args.each_with_index do |value, index|
        result = Aka.remove(value)
        Aka.unalias_the(value) if !options.nounalias && result == true
        Aka.reload_dot_file if result == true && !options.no
      end
    end


    #
    # show version
    #
    desc :version, "show version"
    def version
      puts Aka::VERSION
    end


    #
    # first step: set config file
    #
    desc :setup, "Gem - Setup aka"
    method_options :reset => :boolean
    def setup

      if options.reset? && File.exist?("#{CONFIG_PATH}")
        Aka.remove_autosource
        FileUtils.rm_r("#{CONFIG_PATH}")
        puts "#{CONFIG_PATH} is removed"
      end

      if File.exist?("#{CONFIG_PATH}")
        puts ".aka config file is exist in #{CONFIG_PATH}"
        puts "Please run [aka setup --reset] to remove aka file and setup again"
      else
        Aka.setup_config      # create and setup .config file
        Aka.setup_aka         # put value in .config file
        puts "setting up autosource"
        Aka.setup_autosource  # create, link source file
        puts "Congratulation, aka is setup in #{CONFIG_PATH}"
      end
    end

    #
    # FIND
    #
    desc :find, "find an alias (short alias: f)"
    method_options :force => :boolean
    method_option :group, :type => :string, :aliases => '-g', :desc => ''
    def find *args
      if options.group
        Aka.search_alias_with_group_name(options.group)
      else
        args.each_with_index do |value, index|
          Aka.search_alias_return_alias_tokens(value)
        end
      end
    end

    #
    # EDIT
    #
    desc :edit, "edit an alias(short alias: e)"
    method_options :force => :boolean
    method_options :name => :boolean #--name
    method_option :group, :type => :string, :aliases => '-g', :desc => '', :default => 'default'
    def edit args
      if options.group
          if options.group != 'default'
            puts "Editing for the following alias - "
            answer = ask "do you want to change the group from xxxx to #{options.group}?"
            Aka.change_group_name_with(options.group) if yes?
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
          truth, _alias = Aka.search_alias_return_alias_tokens(args)
          if truth == true
            if options.name
              Aka.remove(_alias) #remove that alias
              Aka.edit_alias_name(values[1], _alias) #edit that alias
              Aka.reload_dot_file if !options.noreload
            else
              Aka.remove(_alias) #remove that alias
              Aka.edit_alias_command(values[1], _alias) #edit that alias
              Aka.reload_dot_file if !options.noreload
            end
          else
            Aka.error_statement("Alias '#{args}' cannot be found.")
          end
        else
          truth, _alias, command = Aka.search_alias_return_alias_tokens(args)
          if truth == true
            if options.name
              input = ask "Enter a new alias for command '#{command}'?\n"
              if yes? "Please confirm the new alias? (y/N)"
                Aka.remove(_alias) #remove that alias
                Aka.edit_alias_name(input, command) #edit that alias
                Aka.reload_dot_file if !options.noreload
              end
            else
              input = ask "Enter a new command for alias '#{args}'?\n"
              if yes? "Please confirm the new command? (y/N)"
                Aka.remove(_alias) #remove that alias
                Aka.edit_alias_command(input, _alias) #edit that alias
                Aka.reload_dot_file if !options.noreload
              end
            end
          else
            Aka.error_statement("Alias '#{args}' cannot be found")
          end
        end
      end #if args
    end

    #
    # LIST OUT - ryan - remove numbering
    #
    desc :list, "list alias (short alias: l)"
    method_options :force => :boolean
    method_options :number => :boolean
    method_option :no, :type => :boolean, :aliases => '-n', :desc => '--no means do not reload'
    method_option :group, :type => :boolean, :aliases => '-g', :desc => ''
    def list(args=nil)
      Aka.print_title("System Alias")
      if args != nil
        Aka.showlast(options.number,args.to_i, options.group) #user input
      else
        value = Aka.readYML("#{CONFIG_PATH}")["list"]
        if value.class == Fixnum
          Aka.showlast(options.number,value.to_i,options.group)
        else
          puts "List value is not defined in #{CONFIG_PATH}"
          Aka.showlast(options.number,50,options.group)
        end
      end
      Aka.print_all_helpful_statement
      Aka.reload_dot_file if !options.no
    end

    #
    # USAGE - ryan - remove numbering in front
    #
    desc "usage [number]", "show commands usage based on history"
    def usage(args=nil)
      if args
        if options.least && args
          Aka.showUsage(args.to_i, true)
        else
          Aka.showUsage(args.to_i)
        end
      else
        if options.least
          value = Aka.readYML("#{CONFIG_PATH}")["usage"]
          Aka.showlast(value.to_i, true) #this is unsafe
        else
          value = Aka.readYML("#{CONFIG_PATH}")["usage"]
          Aka.howlast(value.to_i) #this is unsafe
        end
      end

      if options[:clear]
        puts "clear the dot history file"
      end
    end

    #
    # Config
    #
    desc :config, "show config"
    def config
      Aka.showConfig
    end


    #
    # INIT
    #
    desc :init, "setup aka"
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
        Aka.setup
      else
        Aka.setZSHRC if options[:zshrc]
        Aka.setBASHRC if options[:bashrc]
        Aka.setBASH if options[:bash]

        Aka.showConfig if options[:config]
        Aka.setPath(options[:dotfile],"dotfile") if options[:dotfile]
        Aka.setPath(options[:history],"history") if options[:history]
        Aka.setPath(options[:home],"home") if options[:home]
        Aka.setPath(options[:install],"install") if options[:install]
        Aka.setPath(options[:profile],"profile") if options[:profile]
        Aka.setPath(options[:list],"list") if options[:list]
        Aka.setPath(options[:usage],"usage") if options[:usage]
        Aka.setPath(options[:remote],"remote") if options[:remote]
      end
    end

    #
    # CLEAN
    #
    desc :clean, "perform cleanup on your dot file"
    def clean
      Aka.cleanup
    end


  end #that's all
end #last end
