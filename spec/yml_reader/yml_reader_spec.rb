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
  context 'when configuring the yml directory' do
    before(:each) do
      MyModule.yml_directory = nil
    end

    it 'should store a yml directory' do
      MyModule.yml_directory = 'some_directory'
      expect(MyModule.yml_directory).to eql('some_directory')
    end

    it 'should default to a directory specified by the containing class' do
      expect(MyModule.yml_directory).to eql('default_directory')
    end
  end

  context 'when including files' do
    before(:each) do
      MyModule.yml_directory = File.expand_path('data', File.dirname(__FILE__))
    end

    it 'should load data from included yaml' do
      MyModule.load 'with_includes.yml'
      expect(MyModule.data['include1']['keyn1']).to eql('Value 1')
    end

    it 'should load data from  chained included yaml' do
      MyModule.load 'with_includes.yml'
      expect(MyModule.data['include_chain1']['key_chain_1']).to eql('chain 1')
    end

    it 'should load data from _include_ yaml' do
      MyModule.load 'with_includes.yml'
      expect(MyModule.data['include_nested']['keyn_1']).to eql('Value nested 1')
    end

    it 'should load data from  chained _include_ yaml' do
      MyModule.load 'with_includes.yml'
      expect(MyModule.data['second_chain1']['skey_chain_1']).to eql('schain 1')
    end

    it 'should load data from  nested _include_ yaml' do
      MyModule.load 'with_includes.yml'
      expect(MyModule.data['include_nested']['nested_key']['nested_value']['deep_nested_key']
      ).to eql('deep nested value')
    end
  end

end
