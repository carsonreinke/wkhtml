require 'spec_helper'

RSpec.shared_examples 'settings' do |boolean_setting|
  let(:settings){ described_class.new() }
  
  describe '#initialize' do
    it 'takes initial settings' do
      obj = described_class.new({boolean_setting => 'true'})
      expect(obj[boolean_setting]).to eql('true')
    end
    
    it 'uses defaults' do
      obj = Class.new(described_class) do
        self.default_settings = {boolean_setting => 'true'}
      end.new()
      expect(obj[boolean_setting]).to eql('true')
    end
    
    it 'will override defaults' do
      obj = Class.new(described_class) do
        self.default_settings = {boolean_setting => 'true'}
      end.new({
        boolean_setting => 'false'
      })
      expect(obj[boolean_setting]).to eql('false')
    end
  end
  
  describe '#to_hash' do
    it 'contains setting' do
      settings[boolean_setting] = 'true'
      expect(settings.to_hash[boolean_setting]).to eql('true')
    end
    
    it 'has an alias' do
      expect{settings.to_h}.not_to raise_error
    end
  end
  
  describe '#settings=' do
    let(:mock) do
      Class.new(described_class) do
        self.settings = ['blah']
      end
    end
    
    it 'defines method getter' do
      expect(mock.instance_methods).to include(:blah)
    end
    
    it 'defines method setter' do
      expect(mock.instance_methods).to include(:blah=)
    end
    
    it 'defined method can set' do
      settings.__send__(:"#{boolean_setting}=", 'true')
      expect(settings[boolean_setting]).to eql('true')
    end
    
    it 'defined method can get' do
      settings[boolean_setting] = 'true'
      expect(settings.__send__(:"#{boolean_setting}")).to eql('true')
    end
  end
end