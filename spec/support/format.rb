{
  'jpg' => "\xFF\xD8\xFF\xE0",
  'pdf' => '%PDF-',
  'png' => "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A",
  'svg' => '<?xml',
  'bmp' => "\x42\x4d"
}.each do |format,magic|
  magic.force_encoding(Encoding::BINARY)
  
  RSpec::Matchers.define :"be_#{format}" do
    match do |output|
      output = output.dup()
      output.force_encoding(Encoding::BINARY)
      output = output[0..magic.size]
      output.start_with?(magic)
    end
  end
end