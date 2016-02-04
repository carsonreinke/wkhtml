require 'spec_helper'

RSpec.describe WkHtml do
  it "has a library version" do
    expect(WkHtml::LIBRARY_VERSION).not_to be_nil
  end
end