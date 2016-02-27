require 'spec_helper'
require 'support/to_x_settings'
require 'support/settings'

RSpec.describe WkHtml::ToPdf::GlobalSettings do
  include_examples 'to_x_settings', 'useCompression'
  include_examples 'settings', 'useCompression'
end