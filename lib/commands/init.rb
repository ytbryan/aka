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
        Aka.setZSHRC if options[:zshrc]
        Aka.setBASHRC if options[:bashrc]
        Aka.setBASH if options[:bash]

        Aka.showConfig if options[:config]
        Aka.setPath(options[:dotfile], 'dotfile') if options[:dotfile]
        Aka.setPath(options[:history], 'history') if options[:history]
        Aka.setPath(options[:home], 'home') if options[:home]
        Aka.setPath(options[:install], 'install') if options[:install]
        Aka.setPath(options[:profile], 'profile') if options[:profile]
        Aka.setPath(options[:list], 'list') if options[:list]
        Aka.setPath(options[:usage], 'usage') if options[:usage]
        Aka.setPath(options[:remote], 'remote') if options[:remote]
      end
    end
    
  end
end
