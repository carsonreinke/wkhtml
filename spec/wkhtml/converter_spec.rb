require 'spec_helper'
require 'support/format'
require 'tempfile'

RSpec.describe WkHtml::Converter do
  let(:html_content) {}
  let(:html){ WkHtml::Converter.new('<html><bod>My Test</body></html>') }
  let(:uri){ WkHtml::Converter.new('http://example.com/') }
  
  #Test a bunch of variations
  ['jpg', 'pdf', 'png', 'bmp', 'svg'].each do |format|
    ['internal', 'external'].each do |location|
      context location do
        describe '#to_image' do
          it "returns a #{format}" do
            convert = location == 'internal' ? html : uri
            expect(convert.to_image(format)).to __send__(:"be_#{format}")
          end
        end
        
        describe "#to_#{format}" do
          it "returns a #{format}" do
            convert = location == 'internal' ? html : uri
            expect(convert.to_image(format)).to __send__(:"be_#{format}")
          end
        end
        
        describe '#to_file' do
          it "to write a #{format}" do
            Tempfile.open('wkhtml') do |file|
              convert = location == 'internal' ? html : uri
              convert.to_file(file.path, format)
              expect(IO.read(file)).to __send__(:"be_#{format}")
            end
          end
        end
      end
    end
  end
  
  describe '#initialize' do
    it 'receives initial options' do
      converter = WkHtml::Converter.new('<html><bod>My Test</body></html>', {'documentTitle' => 'Here Is My Test'})
      expect(converter.to_pdf()).to include('Here Is My Test')
    end
  end
end