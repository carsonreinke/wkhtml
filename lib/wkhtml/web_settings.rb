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


__END__
web.background Should we print the background? Must be either "true" or "false".
web.loadImages Should we load images? Must be either "true" or "false".
web.enableJavascript Should we enable javascript? Must be either "true" or "false".
web.enableIntelligentShrinking Should we enable intelligent shrinkng to fit more content on one page? Must be either "true" or "false". Has no effect for wkhtmltoimage.
web.minimumFontSize The minimum font size allowed. E.g. "9"
web.printMediaType Should the content be printed using the print media type instead of the screen media type. Must be either "true" or "false". Has no effect for wkhtmltoimage.
web.defaultEncoding What encoding should we guess content is using if they do not specify it properly? E.g. "utf-8"
web.userStyleSheet Url er path to a user specified style sheet.
web.enablePlugins Should we enable NS plugins, must be either "true" or "false". Enabling this will have limited success.