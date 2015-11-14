module Aka
  ################################################
  ## Getting these babies ready for beauty contest
  ################################################

  def self.showSpace word
    space = ""
    val = 20 - word.size
    val = 20 if val < 0
    val.times do
      space += " "
    end
    return space
  end

  def self.showBar percent
    result = ""
    val = percent/100 * 50
    val = 2 if val > 1 && val < 2
    val = 1 if val.round <= 1 #for visibiity, show two bars if it's just one
    val.round.times do
      result += "+"
    end

    remaining = 50 - val.round
    remaining.times do
      result += "-".red
    end

    return result + " #{percent.round(2)}%"
  end


end

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
