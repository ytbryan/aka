module Aka
  class Base < Thor

    desc :init, 'setup aka'
    method_options dotfile: :string
    method_options history: :string
    method_options install: :string
    method_options profile: :string
    method_options remote: :string
    method_options config: :boolean
    method_options bashrc: :boolean
    method_options usage: :numeric
    method_options zshrc: :boolean
    method_options bash: :boolean
    method_options home: :string
    method_options list: :numeric

    def init
      if options[:count] && options[:count] < 1
        Aka.setup
      else
        Aka.set_ZSH if options[:zshrc]
        Aka.set_BASH if options[:bashrc]
        Aka.setBASH if options[:bash]

        # Aka.showConfig if options[:config]
        Aka.show_config if options[:config]
        Aka.set_path(options[:dotfile], 'dotfile') if options[:dotfile]
        Aka.set_path(options[:history], 'history') if options[:history]
        Aka.set_path(options[:home], 'home') if options[:home]
        Aka.set_path(options[:install], 'install') if options[:install]
        Aka.set_path(options[:profile], 'profile') if options[:profile]
        Aka.set_path(options[:list], 'list') if options[:list]
        Aka.set_path(options[:usage], 'usage') if options[:usage]
        Aka.set_path(options[:remote], 'remote') if options[:remote]
      end
    end
    
  end
end
