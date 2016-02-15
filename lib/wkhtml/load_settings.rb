module WkHtml
  module LoadSettings
    PREFIX = 'load'
    KEYS = %w(
      username
      password
      jsdelay
      zoomFactor
      customHeaders
      repertCustomHeaders
      cookies
      post
      blockLocalFileAccess
      stopSlowScript
      debugJavascript
      loadErrorHandling
      proxy
      runScript
    ).map!{|k| "#{PREFIX}.#{k}" }
  end
end