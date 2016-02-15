module WkHtml
  module WebSettings
    PREFIX = 'web'
    KEYS = %w(
      background
      loadImages
      enableJavascript
      enableIntelligentShrinking
      minimumFontSize
      printMediaType
      defaultEncoding
      userStyleSheet
      enablePlugins
    ).map!{|k| "#{PREFIX}.#{k}" }
  end
end