module Aka
  class Base < Thor

    desc :list, 'list alias (short alias: l)'
    method_options force: :boolean
    method_options number: :boolean
    method_option :no, type: :boolean, aliases: '-n', desc: '--no means do not reload'
    method_option :group, type: :boolean, aliases: '-g', desc: ''
    def list(args = nil)
      Aka.print_title('System Alias')
      if !args.nil?
        Aka.show_last(options[:number], args.to_i, options[:group]) # user input
      else
        value = Aka.read_YML("#{CONFIG_PATH}")['list']
        if value.class == Integer
          Aka.show_last(options[:number], value.to_i, options[:group])
        else
          puts "List value is not defined in #{CONFIG_PATH}"
          Aka.show_last(options[:number], 50, options[:group])
        end
      end
      Aka.print_all_helpful_statement
      Aka.reload_dot_file unless options[:no]
    end

  end
end
