require 'spec_helper'
require 'yaml'

module MyModule
  extend YmlReader

  def self.data
    @yml
  end
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

  context 'when including files' do
    before(:each) do
      MyModule.yml_directory = File.expand_path('data', File.dirname(__FILE__))
    end

    it 'should load data from included yaml' do
      MyModule.load 'with_includes.yml'
      MyModule.data['include_1']['key_1'].should == 'Value 1'
    end
  end

  context 'when loading data from multiple files' do
    before(:each) do
      MyModule.yml_directory = File.expand_path('data', File.dirname(__FILE__))
    end
    
    it 'should merge the data in all files' do
      MyModule.load 'file_1_out_of_3.yml,file_2_out_of_3.yml,file_3_out_of_3.yml'
      3.times do |file_number|
        MyModule.data['first_field_from_file_#{file_number}'] == 'read_from_file_#{file_number}'
      end
    end
  end

end
