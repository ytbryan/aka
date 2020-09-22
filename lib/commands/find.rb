module Aka
  class Base < Thor
    desc :find, 'find an alias (short alias: f)'
    method_options force: :boolean
    method_option :group, type: :string, aliases: '-g', desc: ''
    def find(*args)
      if options[:group]
        Aka.search_alias_with_group_name(options[:group])
      else
        args.each_with_index do |value, _index|
          Aka.search_alias_return_alias_tokens(value)
        end
      end
      true
    end
    
  end
end
