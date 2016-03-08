module WkHtml
  module ToImage
    class GlobalSettings
      include Settings

      KEYS = %w(
        crop.left
        crop.top
        crop.width
        crop.height
        load.cookieJar
        transparent
        in
        out
        fmt
        screenWidth
        smartWidth
        quality
      )
      DEFAULTS = {
        'fmt' => CommonSettings::JPG
      }

      self.settings = WebSettings::KEYS + LoadSettings::KEYS + KEYS
      self.default_settings = DEFAULTS

      def in=(v)
        v = CommonSettings::cleanup_path(v)
        raise ArgumentError.new("#{v} is missing or not readable") unless CommonSettings::readable?(v)
        self['in'] = v
      end

      def out=(v)
        v = CommonSettings::cleanup_path(v)
        raise ArgumentError.new("#{v} is not writeable") unless CommonSettings::writable?(v)
        self['out'] = v
      end

      def stdin=(v)
        self.in = v ? CommonSettings::STDIN : nil
      end

      def stdout=(v)
        self.out = v ? CommonSettings::STDOUT : nil
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