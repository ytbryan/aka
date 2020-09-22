module Aka
  class Base < Thor

    desc :proj, 'list the project alias (short alias: p)'
    method_option :group, type: :boolean, aliases: '-g'
    method_option :load, type: :string, aliases: '-l'
    method_option :save, type: :string, aliases: '-s'
    method_option :force, type: :boolean, aliases: '-f'

    def proj(arg = nil)
      if options[:load]
        Aka.export(arg, options[:load], options[:force])
      elsif options[:save]
        Aka.import(options[:save])
      else
        if options[:group] && File.exist?('proj.aka')
          Aka.list_all_groups_in_proj_aka
        elsif options[:group] && !File.exist?('proj.aka')
          Aka.error_statement('The proj.aka is missing. Please run [aka proj --load <name_of_group>] to generate proj.aka file')
        else
          if File.exist?('proj.aka')
            if content = File.open('proj.aka').read
              Aka.print_title('Project Alias')
              content_array = Aka.product_content_array(content)
              answer_count = Aka.print_the_aliases(content_array)
              Aka.print_helpful_statement(answer_count)
            end
          else
            Aka.error_statement('The proj.aka is missing. Please run [aka proj --load <name_of_group>] to generate proj.aka file')
          end
        end
      end # end of when
    end

  end
end
