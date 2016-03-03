require 'spec_helper'

RSpec.describe WkHtml::ToImage::Converter do
  let(:html_content) {'<html><bod>My Test</body></html>'}

  it "can create" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    expect(WkHtml::ToImage::Converter.create(settings, nil)).not_to be_nil
  end
  
  it "cannot use new" do
    expect{WkHtml::ToImage::Converter.new()}.to raise_error(NoMethodError)
  end
  
  it "should raise when create missing settings" do
    expect{WkHtml::ToImage::Converter.create('', nil)}.to raise_error(ArgumentError)
  end
  
  it "can convert html" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    settings['fmt'] = 'jpeg'
    converter = WkHtml::ToImage::Converter.create(settings, html_content)
    expect(converter.convert).to be true
  end
  
  it "can convert external" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    settings['in'] = 'http://example.com/'
    settings['fmt'] = 'jpeg'
    converter = WkHtml::ToImage::Converter.create(settings, nil)
    expect(converter.convert).to be true
  end
  
  it "should not allow multiple converts" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    settings['fmt'] = 'jpeg'
    converter = WkHtml::ToImage::Converter.create(settings, html_content)
    expect(converter.convert).to be true
    expect{converter.convert}.to raise_error(RuntimeError)
  end
  
  it "should freeze settings after convert" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    converter = WkHtml::ToImage::Converter.create(settings, nil)
    converter.convert
    expect(settings.frozen?).to be true
  end
  
  it "can get http error code" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    settings['in'] = 'http://example.com/'
    settings['fmt'] = 'jpeg'
    converter = WkHtml::ToImage::Converter.create(settings, nil)
    converter.convert()
    expect(converter.http_error_code).to be_nil
  end
  
  it "can get output" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    settings['in'] = 'http://example.com/'
    settings['fmt'] = 'jpeg'
    converter = WkHtml::ToImage::Converter.create(settings, nil)
    converter.convert()
    output = converter.get_output().encode!(Encoding::BINARY)[0..3]
    expect(output).to start_with("\xFF\xD8\xFF\xE0".force_encoding(Encoding::BINARY)) #JPEG
  end
  
  it "raises when converting on thread" do
    settings = WkHtml::ToImage::GlobalSettings.new()
    settings['fmt'] = 'jpeg'
    converter = WkHtml::ToImage::Converter.create(settings, html_content)
    
    expect do
      Thread.new{ converter.convert() }.join()
    end.to raise_error(RuntimeError)
  end
end
