require 'spec_helper'
require 'support/to_x_settings'
require 'support/settings'

RSpec.describe WkHtml::ToPdf::ObjectSettings do
  include_examples 'to_x_settings', 'useExternalLinks'
  include_examples 'settings', 'useExternalLinks'
end