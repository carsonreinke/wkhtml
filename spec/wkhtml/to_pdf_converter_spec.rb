require 'spec_helper'

RSpec.describe WkHtml::ToPdf::Converter do
  it "can create" do
    settings = WkHtml::ToPdf::GlobalSettings.new()
    expect(WkHtml::ToPdf::Converter.create(settings)).not_to be_nil
  end
  
  it "cannot use new" do
    expect{WkHtml::ToPdf::Converter.new()}.to raise_error
  end
  
  it "can add object nil" do
    converter = WkHtml::ToPdf::Converter.create(WkHtml::ToPdf::GlobalSettings.new())
    expect(converter.add_object(WkHtml::ToPdf::ObjectSettings.new(), nil)).to be_nil
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
end