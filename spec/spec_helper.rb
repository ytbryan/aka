require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'aka2'
require "stringio"

RSpec.configure do |config|
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end
