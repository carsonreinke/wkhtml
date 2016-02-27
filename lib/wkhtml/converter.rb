module WkHtml
  class Converter
    #
    class Failed < StandardError
      attr_reader :http_error_code

      def initialize(http_error_code)
        @http_error_code = http_error_code
        super(@http_error_code.nil?() ? "Conversion failed" : "Conversion failed with HTTP status #{@http_error_code}")
      end
    end

    def initialize(data, options = {})
      @data = data
      @options = options
      
      #TODO
      @use_data = case @data
      when String
        !(@data =~ /^http[s]?:\/\//)
      when File
        @data = @data.path
        false
      else
        false
      end
    end

    #
    #
    #
    def to_file(path, format = nil)
      path = path.path if path.is_a?(File)

      unless format
        #Use file extension if available
        format = File.extname(path)
        format.sub!(/^\./, '')
        format = nil if format.empty?()
      end
      format ||= CommonSettings::JPG

      native_converter = if format == CommonSettings::PDF
        create_pdf_converter do |s|
          s.out = path
        end
      else
        create_image_converter do |s|
          s.fmt = format
          s.out = path
        end
      end

      unless native_converter.convert()
        raise Failed.new(native_converter.http_error_code())
      end

      path
    end

    #
    #
    #
    def to_image(format = CommonSettings::JPG)
      native_converter = if format == CommonSettings::PDF
        create_pdf_converter()
      else
        create_image_converter do |s|
          s.fmt = format
        end
      end

      unless native_converter.convert()
        raise Failed.new(native_converter.http_error_code())
      end
      native_converter.get_output()
    end

    def to_pdf(); self.to_image(CommonSettings::PDF); end
    def to_jpg(); self.to_image(CommonSettings::JPG); end
    def to_png(); self.to_image(CommonSettings::PNG); end
    def to_bmp(); self.to_image(CommonSettings::BMP); end
    def to_svg(); self.to_image(CommonSettings::SVG); end


  protected
    def create_pdf_converter(&block)
      global_settings = build_settings(WkHtml::ToPdf::GlobalSettings)
      object_settings = build_settings(WkHtml::ToPdf::ObjectSettings)
      object_settings.page = @data unless @use_data
      yield global_settings, object_settings if block_given?()
      native_converter = WkHtml::ToPdf::Converter.create(global_settings)
      native_converter.add_object(object_settings, @use_data ? @data : nil)
      native_converter
    end

    def create_image_converter(&block)
      global_settings = build_settings(WkHtml::ToImage::GlobalSettings)
      global_settings.in = @data unless @use_data
      yield global_settings if block_given?()
      native_converter = WkHtml::ToImage::Converter.create(global_settings, @use_data ? @data : nil)
      native_converter
    end

    def build_settings(klass)
      settings = klass.new()
      (@options.keys & settings.class.settings).each do |key,value|
        settings[key] = value
      end
      settings
    end
  end
end