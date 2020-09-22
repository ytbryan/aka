# coding: utf-8
require_relative "spec_helper"

# TODO set the PATH to a seperate testing 

describe Aka do 
  it "should have a version number" do 
    expect(Aka::VERSION).not_to be_empty
  end

  it "should add a task" do 
    # expect(capture(:stdout){
    #   Doerlist::Base.new.invoke(:add, ['something'])
    # }.strip).to eq("ADDED: something -> #{Doerlist::Base::PATH}")
  end

  it "should remove a task" do 
    # title = "something"
    # expect(capture(:stdout){
    #   Doerlist::Base.new.invoke(:destroy, [title])
    # }.strip).to eq("DELETED: #{Doerlist::Base::PATH}#{title}.md into Trash")

  end

  it "should find a task" do 
  end

  it "should move a task" do 
  end

  it "should list all tasks" do 
  end

  it "should finish a task" do 
  end

end
