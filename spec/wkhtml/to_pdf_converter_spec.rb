require 'spec_helper'

RSpec.describe WkHtml::ToPdf::Converter do
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
    html = <<-HTML
      <html>
      <body>
        My Test
      </body>
      </html>
    HTML
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    expect(converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), html)).to eq(html)
  end
  
  it "can convert html" do
    html = <<-HTML
      <html>
      <body>
        My Test
      </body>
      </html>
    HTML
    settings = WkHtml::ToPdf::GlobalSettings.new()
    converter = WkHtml::ToPdf::Converter.create(settings)
    converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), html)
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
    html = <<-HTML
      <html>
      <body>
        My Test
      </body>
      </html>
    HTML
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), html)
    converter.convert()
    expect{converter.convert}.to raise_error(RuntimeError)
  end
  
  it "should freeze settings after convert" do
    html = <<-HTML
      <html>
      <body>
        My Test
      </body>
      </html>
    HTML
    settings = WkHtml::ToPdf::ObjectSettings.new()
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    converter.add_object(settings, html)
    converter.convert
    expect(settings.frozen?).to be true
  end
end