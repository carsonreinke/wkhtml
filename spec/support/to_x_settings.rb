require 'spec_helper'

RSpec.shared_examples 'to_x_settings' do |boolean_setting|
  let(:settings){ described_class.new() }
  
  describe '#initialize' do
    it 'can create' do
      expect(settings).not_to be_nil
    end
  end
  
  describe '#[]' do
    it 'can get' do
      expect{ settings[boolean_setting] }.to_not raise_error
    end
    
    it 'raises error when unknown' do
      expect{ settings['blah'] }.to raise_error(ArgumentError)
    end
    
    it 'can use a symbol' do
      expect{ settings[boolean_setting.to_sym] }.to_not raise_error
    end
  end
  
  describe '#[]=' do
    it 'can set' do
      expect(settings[boolean_setting] = 'true').to eq('true')
    end
    
    it 'raises error when unknown' do
      expect{ settings['blah'] = '' }.to raise_error(ArgumentError)
    end
    
    it 'can use a symbol' do
      expect(settings[boolean_setting.to_sym] = 'true').to eq('true')
    end
  end
end