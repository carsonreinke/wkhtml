require 'spec_helper'

RSpec.describe WkHtml::ToPdf::GlobalSettings do
  it "can create" do
    expect(WkHtml::ToPdf::GlobalSettings.new()).not_to be_nil
  end
  
  it "can set" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    expect(settings['useCompression'] = 'true').to eq('true')
  end
  
  it "can get" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    expect(settings['useCompression']).not_to be_nil
  end
  
  it "unknown get" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    expect{ settings['blah'] }.to raise_error(ArgumentError)
  end
  
  it "unknown set" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    expect{ settings['blah'] = '' }.to raise_error(ArgumentError)
  end
  
  it "can use a symbol" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    expect(settings[:useCompression] = 'true').to eq('true')
    expect(settings[:useCompression]).to eq('true')
  end
end