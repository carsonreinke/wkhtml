module WkHtml
  module HeaderSettings
    HEADER_PREFIX = 'header'
    FOOTER_PREFIX = 'footer'
    KEYS = %w(
      fontSize
      fontName
      left
      center
      right
      line
      spacing
      htmlUrl
    ).map!{|k| ["#{HEADER_PREFIX}.#{k}", "#{FOOTER_PREFIX}.#{k}"] }.flatten()
  end
end


__END__
header.fontSize The font size to use for the header, e.g. "13"
header.fontName The name of the font to use for the header. e.g. "times"
header.left The string to print in the left part of the header, note that some sequences are replaced in this string, see the wkhtmltopdf manual.
header.center The text to print in the center part of the header.
header.right The text to print in the right part of the header.
header.line Whether a line should be printed under the header (either "true" or "false").
header.spacing The amount of space to put between the header and the content, e.g. "1.8". Be aware that if this is too large the header will be printed outside the pdf document. This can be corrected with the margin.top setting.
header.htmlUrl Url for a HTML document to use for the header.