module Aka
  class Base < Thor
    desc :destroy, 'destroy an alias (short alias: d)'
    method_options force: :boolean
    method_option :no, type: :boolean, aliases: '-n', desc: '--no means do not reload'
    method_option :nounalias, type: :boolean, aliases: '-u', desc: '--nounalias means do not remove the alias from current shell'

    def destroy(*args)
      args.each_with_index do |value, _index|
        result = Aka.remove(value)
        Aka.unalias_the(value) if !options[:nounalias] && result == true
        Aka.reload_dot_file if result == true && !options[:no]
      end
      true
    end
  end
end

