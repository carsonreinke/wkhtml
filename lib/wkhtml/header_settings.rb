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