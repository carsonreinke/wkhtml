require 'spec_helper'

RSpec.describe WkHtml::ToImage::GlobalSettings do
  it "can create" do
    expect(WkHtml::ToImage::GlobalSettings.new()).not_to be_nil
  end
  
  it "can set" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    expect(settings['transparent'] = 'true').to eq('true')
  end
  
  it "can get" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    expect(settings['transparent']).not_to be_nil
  end
  
  it "unknown get" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    expect{ settings['blah'] }.to raise_error(ArgumentError)
  end
  
  it "unknown set" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    expect{ settings['blah'] = '' }.to raise_error(ArgumentError)
  end
  
  it "can use a symbol" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    expect(settings[:transparent] = 'true').to eq('true')
    expect(settings[:transparent]).to eq('true')
  end
end