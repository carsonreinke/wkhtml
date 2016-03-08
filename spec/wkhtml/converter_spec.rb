require 'spec_helper'
require 'support/format'
require 'tempfile'

RSpec.describe WkHtml::Converter do
  let(:html_content) {'<html><bod>My Test</body></html>'}
  let(:html){ WkHtml::Converter.new(html_content) }
  let(:uri){ WkHtml::Converter.new('http://example.com/') }
  let(:file){ WkHtml::Converter.new(File.new(File.join(File.dirname(__FILE__), '..', 'support', 'test.html'))) }
  
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
      convert = WkHtml::Converter.new(html_content, {'documentTitle' => 'Here Is My Test'})
      expect(convert.to_pdf().force_encoding(Encoding::BINARY)).to include("/Title (\xFE\xFF\x00H\x00e\x00r\x00e\x00 \x00I\x00s\x00 \x00M\x00y\x00 \x00T\x00e\x00s\x00t)".force_encoding(Encoding::BINARY))
    end
    
    it 'can use a file' do
      convert = file
      expect(convert.to_pdf()).to be_pdf
      expect(convert.to_jpg()).to be_jpg
    end
  end
  
  describe '#to_image' do
    it 'raises when file is missing' do
      temp = Tempfile.new('wkhtml')
      file = File.new(temp.path)
      temp.close()
      temp.unlink()
      convert = WkHtml::Converter.new(file)
      expect{convert.to_image('pdf')}.to raise_error(ArgumentError)
      expect{convert.to_image('jpg')}.to raise_error(ArgumentError)
    end
  end
  
  describe '#to_file' do
    it 'creates when file is missing' do
      temp = Tempfile.new('wkhtml')
      file = File.new(temp.path)
      temp.close()
      temp.unlink()
      convert = html
      
      expect(convert.to_file(file, 'pdf')).to eql(file.path)
      expect(convert.to_file(file, 'jpg')).to eql(file.path)
      expect(File.exists?(file.path)).to be true
    end
  end
end