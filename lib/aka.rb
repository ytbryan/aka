require_relative 'import_libraries'

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
    #   system("atom #{Aka.read_YML("#{CONFIG_PATH}")['dotfile']}")
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
      # Aka.showConfig
      Aka.show_config
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
      puts Aka.read_YML("#{CONFIG_PATH}")['dotfile']
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

class String
  def pretty
  self.gsub("\s\t\r\f", ' ').squeeze(' ')
  end

  def is_i?
  !!(self =~ /\A[-+]?[0-9]+\z/)
  end

  def colorize(color_code)
   "\e[#{color_code}m#{self}\e[0m"
  end

  def red
   colorize(31)
  end

  def green
   colorize(32)
  end

  def yellow
   colorize(33)
  end

  def blue
   colorize(34)
  end

  def pink
   colorize(35)
  end

  def light_blue
   colorize(36)
  end
end
