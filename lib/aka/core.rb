module Aka
  def self.reload_dot_file
    isOhMyZsh == TRUE ? system("exec zsh") : system("kill -SIGUSR1 #{Process.ppid}")
  end

  def self.unalias_the value
    if isOhMyZsh == TRUE
      system("exec zsh")
    else
      system "echo '#{value}' > ~/sigusr1-args;"
      system "kill -SIGUSR2 #{Process.ppid}"
    end
  end

end
