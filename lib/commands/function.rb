module Aka
  class Base < Thor
        
    desc :function, 'generate a function'
    method_option :last, type: :boolean, aliases: '-l', desc: ''
    method_option :group, type: :string, aliases: '-g', desc: '', default: 'default'
    method_option :no, type: :boolean, aliases: '-n', desc: '--no means do not reload'
    method_option :empty, type: :boolean, aliases: '-e', desc: 'do not print anything'
    def function args
      puts "function"

      result = Aka.add_a_function(Aka.parseARGS(args), options[:group])

      # result = false
      # if options[:last] && args
      #   result = Aka.add_with_group(Aka.add_last_command(Aka.parseARGS(args)))
      # else
      #   result = Aka.add_with_group(Aka.parseARGS(args), options[:group])
      # end
      Aka.reload_dot_file if result == true && !options[:no]
      true
    end
  end
end
