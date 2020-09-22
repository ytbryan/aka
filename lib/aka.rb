require_relative 'aka_helper'

module Aka
  class Base < Thor
    check_unknown_options!
    package_name 'aka'
    default_task :list
    map 'g' => :generate,
        'd' => :destroy,
        'f' => :find,
        'u' => :usage,
        'l' => :list,
        'e' => :edit,
        'c' => :clean,
        'h' => :help,
        'v' => :version,
        'dl' => :download,
        'func' => :function

        desc :download, 'download a dotfile'
        def download url
          # open('image.png', 'wb') do |file|
          #   file << open('http://example.com/image.png').read
          # end

          system("curl -O #{url}")
        end

    # desc :open, 'open my dotfile for development'
    # def open
    #   system("atom #{Aka.readYML("#{CONFIG_PATH}")['dotfile']}")
    # end
    #
    # desc :testing, 'testing'
    # def testing(_name, _number)
    #   inp = $stdin.read
    #   puts inp
    # end
    #
    # desc :test, 'this is where we test our code'
    # def test
    #   output = []
    #   r, io = IO.pipe
    #   fork do
    #     # system (%(zsh -c 'source ~/.zshrc; aka generate something=\"echo well well\" --no'), out: io, err: :out)
    #     system("zsh -c 'source ~/.zshrc; aka generate something=\"echo well well\" --no; ${=aliases[something]}'", out: io, err: :out)
    #     # system("ruby", "-e 3.times{|i| p i; sleep 1}", out: io, err: :out)
    #   end
    #   io.close
    #   r.each_line { |l| puts l; output << l.chomp }
    #   p output
    #   puts 'boo'
    # end


    #
    # CLEAN
    #
    desc :clean, 'perform cleanup on your dot file'
    def clean
      Aka.cleanup
    end

    #
    # Config
    #
    desc :config, 'show config'
    def config
      Aka.showConfig
    end

    #
    # Groups
    #
    desc :groups, 'list all the groups'
    def groups
      Aka.list_all_groups
    end

    #
    # Where is your dotfile
    #
    desc :where, 'locate your dotfile'
    def where
      puts Aka.readYML("#{CONFIG_PATH}")['dotfile']
    end

    #
    # show version
    #
    desc :version, 'show version'
    def version
      puts Aka::VERSION
    end


  end # that's all
end # last end
