require 'spec_helper'
require 'support/to_x_settings'
require 'support/settings'

RSpec.describe WkHtml::ToImage::GlobalSettings do
  include_examples 'to_x_settings', 'transparent'
  include_examples 'settings', 'transparent'
end