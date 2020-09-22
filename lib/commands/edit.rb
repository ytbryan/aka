module Aka
  class Base < Thor

    desc :edit, 'edit an alias(short alias: e)'
    method_options force: :boolean
    method_options name: :boolean #--name
    method_option :group, type: :string, aliases: '-g', desc: ''
    def edit(args)
      if options[:group]
        Aka.change_alias_group_name_with(Aka.parseARGS(args), options[:group])
      else
        if args
          values = args.split('=')
          if values.size > 1
            truth, _alias = Aka.search_alias_return_alias_tokens(args)
            if truth == true
              if options[:name]
                # Aka.remove(_alias) #remove that alias
                Aka.edit_alias_name(values[1], _alias) # edit that alias
                Aka.reload_dot_file unless options[:noreload]
              else
                # Aka.remove(_alias) #remove that alias
                Aka.edit_alias_command(values[1], _alias) # edit that alias
                Aka.reload_dot_file unless options[:noreload]
              end
            else
              Aka.error_statement("Alias '#{args}' cannot be found.")
            end
          else
            puts "this is passed in #{args}"
            truth, _alias, command, group = Aka.search_alias_return_alias_tokens_with_group(args)
            if truth == true
              if options[:name]
                input = ask "Enter a new alias for command '#{command}'?\n"
                if yes? 'Please confirm the new alias? (y/N)'
                  Aka.remove(_alias) # remove that alias
                  Aka.edit_alias_name_with_group(input, command, group) # edit that alias
                  Aka.reload_dot_file unless options[:noreload]
                end
              else
                input = ask "Enter a new command for alias '#{args}'?\n"
                if yes? 'Please confirm the new command? (y/N)'
                  Aka.remove(_alias) # remove that alias
                  Aka.edit_alias_command_with_group(input, _alias, group) # edit that alias
                  Aka.reload_dot_file unless options[:noreload]
                end
              end
            else
              Aka.error_statement("Alias '#{args}' cannot be found")
            end
          end
        end # if args
      end # end else no group option
    end

  end
end
