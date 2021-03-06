# coding: utf-8
require_relative "spec_helper"

describe Aka do 
  it "should have a version number" do 
    expect(Aka::VERSION).not_to be_empty
  end

  # TODO need to switch off autosourcing to allow testing to be successful?
  it "should generate an alias" do 
    puts "here"
    expect(capture(:stdout){
      Aka::Base.new.invoke(:generate, ['something1231213=echo something'])
    }.strip).to eq("Created: aka g something12312312='echo something' in default group.")
  end

  # TODO need to switch off autosourcing to allow testing to be successful?
  it "should remove an alias" do 
    expect(capture(:stdout){
      Aka::Base.new.invoke(:destroy, ['something1231213'])
    }.strip).to eq("Removed: aka g something1231213='echo something' -g default")
  end
end
