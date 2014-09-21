require 'spec_helper'
require 'yaml'

module MyModule
  extend YmlReader

  def self.default_directory
    'default_directory'
  end
end

describe YmlReader do
  context "when configuring the yml directory" do
    before(:each) do
      MyModule.yml_directory = nil
    end
    
    it "should store a yml directory" do
      MyModule.yml_directory = 'some_directory'
      MyModule.yml_directory.should == 'some_directory'
    end

    it "should default to a directory specified by the containing class" do
      MyModule.yml_directory.should == 'default_directory'
    end
  end

end
