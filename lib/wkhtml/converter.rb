require 'tempfile'

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
      #Thanks http://stackoverflow.com/questions/800122/best-way-to-convert-strings-to-symbols-in-hash
      @options = options.inject({}){|memo,(k,v)| memo[k.to_s()] = v; memo} #Force string for easy comparison with allowed settings
      
      #Handle multiple inbound types
      @use_data = case @data
      when String
        !(@data =~ CommonSettings::REGEXP_URI)
      when File, Tempfile
        @data = @data.path
        false
      when URI
        @data = @data.to_s()
        false
      else
        false
      end
    end

    #
    #
    #
    def to_file(path, format = nil)
      path = CommonSettings::cleanup_path(path)

      unless format
        #Use file extension if available
        format = File.extname(path)
        format.sub!(/^\./, '')
        format = nil if format.empty?()
      end
      format ||= CommonSettings::JPG
      format = format.to_s()

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
      (@options.keys & settings.class.settings).each do |key|
        local_key = key.tr('.', '_')
        if settings.class.public_method_defined?(local_key) #Use the instance method instead
          settings.__send__(:"#{local_key}=", @options[key])
        else #Does not exist, just go for raw []=
          settings[key] = @options[key]
        end
      end
      settings
    end
  end
end