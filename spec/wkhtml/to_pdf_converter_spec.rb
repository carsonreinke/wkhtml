require 'spec_helper'

RSpec.describe WkHtml::ToPdf::Converter do
  let(:html_content) {'<html><bod>My Test</body></html>'}
  
  it "can create" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    expect(WkHtml::ToPdf::Converter.create(settings)).not_to be_nil
  end
  
  it "cannot use new" do
    expect{WkHtml::ToPdf::Converter.new()}.to raise_error(NoMethodError)
  end
  
  it "should raise when create missing settings" do
    expect{WkHtml::ToPdf::Converter.create('')}.to raise_error(ArgumentError)
  end
  
  it "can add object nil" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    expect(converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), nil)).to be_nil
  end
  
  it "should raise when add object missing settings" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    expect{converter.add_object('', nil)}.to raise_error(ArgumentError)
  end
  
  it "can add object html" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    expect(converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), html_content)).to eq(html_content)
  end
  
  it "can convert html" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    converter = WkHtml::ToPdf::Converter.create(settings)
    converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), html_content)
    expect(converter.convert).to be true
  end
  
  it "can convert external" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    settings = WkHtml::ToPdf::ObjectSettings.new()
    settings['page'] = 'http://example.com/'
    converter.add_object(settings, nil)
    expect(converter.convert).to be true
  end
  
  it "should raise when no object added" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    expect{converter.convert}.to raise_error(RuntimeError)
  end
  
  it "should not allow multiple converts" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), html_content)
    converter.convert()
    expect{converter.convert}.to raise_error(RuntimeError)
  end
  
  it "should freeze settings after convert" do
    settings = WkHtml::ToPdf::ObjectSettings.new()
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    converter.add_object(settings, html_content)
    converter.convert
    expect(settings.frozen?).to be true
  end
  
  it "can get http error code" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    settings = WkHtml::ToPdf::ObjectSettings.new()
    settings['page'] = 'http://example.com/'
    converter.add_object(settings, nil)
    converter.convert()
    expect(converter.http_error_code).to be_nil
  end
  
  it "can get output" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    settings = WkHtml::ToPdf::ObjectSettings.new()
    settings['page'] = 'http://example.com/'
    converter.add_object(settings, nil)
    converter.convert()
    output = converter.get_output()
    expect(output).to_not be_nil
    expect(output).to start_with('%PDF-')
  end
  
  it "raises when converting on thread" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    converter = WkHtml::ToPdf::Converter.create(settings)
    converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), html_content)
    
    expect do
      Thread.new{ converter.convert() }.join()
    end.to raise_error(RuntimeError)
  end
end