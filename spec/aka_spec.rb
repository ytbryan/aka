# coding: utf-8
require_relative "spec_helper"
require_relative "../lib/aka"

describe Aka do 
  it "should have a version number" do 
    expect(Aka::VERSION).not_to be_empty
  end

  it "should generate an alias" do 
    expect(capture(:stdout){
      Aka::Base.new.invoke(:generate, ['something1231213="echo something"'])
    }.strip).to eq("ADDED: something -> #{Doerlist::Base::PATH}")
  end

  it "should remove an alias" do 
    expect(capture(:stdout){
      Aka::Base.new.invoke(:destroy, ['something1231213'])
    }.strip).to eq("Exist:  aka g something1231213='echo something' -g default")
  end
end
