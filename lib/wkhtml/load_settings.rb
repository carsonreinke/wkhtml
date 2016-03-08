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


__END__
load.username The user name to use when loging into a website, E.g. "bart"
load.password The password to used when logging into a website, E.g. "elbarto"
load.jsdelay The mount of time in milliseconds to wait after a page has done loading until it is actually printed. E.g. "1200". We will wait this amount of time or until, javascript calls window.print().
load.zoomFactor How much should we zoom in on the content? E.g. "2.2".
load.customHeaders TODO
load.repertCustomHeaders Should the custom headers be sent all elements loaded instead of only the main page? Must be either "true" or "false".
load.cookies TODO
load.post TODO
load.blockLocalFileAccess Disallow local and piped files to access other local files. Must be either "true" or "false".
load.stopSlowScript Stop slow running javascript. Must be either "true" or "false".
load.debugJavascript Forward javascript warnings and errors to the warning callback. Must be either "true" or "false".
load.loadErrorHandling How should we handle obejcts that fail to load. Must be one of:
"abort" Abort the convertion process
"skip" Do not add the object to the final output
"ignore" Try to add the object to the final output.
load.proxy String describing what proxy to use when loading the object.
load.runScript TODO