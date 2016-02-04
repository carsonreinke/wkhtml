require 'spec_helper'

RSpec.describe WkHtml::ToPdf do
  it "can initialize" do
    expect(WkHtml::ToPdf.init()).to be true
  end
  
  
end