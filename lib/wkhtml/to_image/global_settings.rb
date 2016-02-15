module WkHtml
  module ToImage
    class GlobalSettings
      include Settings
      
      DEFAULTS = {:fmt => 'jpeg'}
      
      KEYS = %w(
        fmt
      )
      
      self.define_attributes(WebSettings::KEYS + LoadSettings::KEYS + KEYS)
      
      def initialize(options = {})
        options = DEFAULTS.merge(options)
        options.each{|key,value| self[key] = value}
      end
      
      def stdin=(v)
        self[:in] = v ? '-' : ''
      end
      
      def stdout=(v)
        self[:out] = v ? '-' : ''
      end
    end
  end
end


__END__

    crop.left left/x coordinate of the window to capture in pixels. E.g. "200"
    crop.top top/y coordinate of the window to capture in pixels. E.g. "200"
    crop.width Width of the window to capture in pixels. E.g. "200"
    crop.height Height of the window to capture in pixels. E.g. "200"
    load.cookieJar Path of file used to load and store cookies.
    load.* Page specific settings related to loading content, see Object Specific loading settings.
    web.* See Web page specific settings.
    transparent When outputting a PNG or SVG, make the white background transparent. Must be either "true" or "false"
    in The URL or path of the input file, if "-" stdin is used. E.g. "http://google.com"
    out The path of the output file, if "-" stdout is used, if empty the content is stored to a internalBuffer.
    fmt The output format to use, must be either "", "jpg", "png", "bmp" or "svg".
    screenWidth The with of the screen used to render is pixels, e.g "800".
    smartWidth Should we expand the screenWidth if the content does not fit? must be either "true" or "false".
    quality The compression factor to use when outputting a JPEG image. E.g. "94".