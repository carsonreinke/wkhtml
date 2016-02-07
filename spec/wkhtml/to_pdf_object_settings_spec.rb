require 'spec_helper'

RSpec.describe WkHtml::ToPdf::ObjectSettings do
  it "can create" do
    expect(WkHtml::ToPdf::ObjectSettings.new()).not_to be_nil
  end
  
  it "can set" do
    settings = WkHtml::ToPdf::ObjectSettings.new()
    expect(settings['useExternalLinks'] = 'true').to eq('true')
  end
  
  it "can get" do
    settings = WkHtml::ToPdf::ObjectSettings.new()
    expect(settings['useExternalLinks']).not_to be_nil
  end
  
  it "unknown get" do
    settings = WkHtml::ToPdf::ObjectSettings.new()
    expect{ settings['blah'] }.to raise_error(ArgumentError)
  end
  
  it "unknown set" do
    settings = WkHtml::ToPdf::ObjectSettings.new()
    expect{ settings['blah'] = '' }.to raise_error(ArgumentError)
  end
end