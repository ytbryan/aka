module Aka
  class Base < Thor
    desc :generate, 'generate an alias (short alias: g)'
    method_option :last, type: :boolean, aliases: '-l', desc: ''
    method_option :group, type: :string, aliases: '-g', desc: '', default: 'default'
    method_option :no, type: :boolean, aliases: '-n', desc: '--no means do not reload'
    method_option :empty, type: :boolean, aliases: '-e', desc: 'do not print anything'
    def generate(args)
      result = false
      puts "here!!"
      if options[:last] && args
              puts "here!!333"

        result = Aka.add_with_group(Aka.add_last_command(Aka.parseARGS(args)))
      else
              puts "here4444"

        result = Aka.add_with_group(Aka.parseARGS(args), options[:group])
      end
      puts "here?"
      Aka.reload_dot_file if result == true && !options[:no]
      true
    end
  end
end
