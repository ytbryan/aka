module Aka
  class Base < Thor

    desc 'usage [number]', 'show commands usage based on history'
    def usage(args = nil)
      if args
        if options[:least] && args
          Aka.showUsage(args.to_i, true)
        else
          Aka.showUsage(args.to_i)
        end
      else
        if options[:least]
          value = Aka.readYML("#{CONFIG_PATH}")['usage']
          Aka.showlast(value.to_i, true) # this is unsafe
        else
          value = Aka.readYML("#{CONFIG_PATH}")['usage']
          Aka.howlast(value.to_i) # this is unsafe
        end
      end

      puts 'clear the dot history file' if options[:clear]
    end
    
  end
end
