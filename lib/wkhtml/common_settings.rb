require 'uri'
require 'fileutils'
require 'tempfile'

module WkHtml
  module CommonSettings
    TRUE = 'true'
    FALSE = 'false'
    STDIN = STDOUT = '-'
    PDF = 'pdf'
    JPG = 'jpg'
    PNG = 'png'
    BMP = 'bmp'
    SVG = 'svg'
    REGEXP_URI = /\A#{URI.regexp(['http', 'https'])}/

    class << self
      def cleanup_path(path)
        path = path.path if path.is_a?(File) || path.is_a?(Tempfile)
        
        if path == STDIN || path == STDOUT
          path
        elsif path =~ REGEXP_URI
          URI.parse(path).to_s()
        else
          File.expand_path(path)
        end
      end
      
      def readable?(path)
        unless path =~ REGEXP_URI
          File.exists?(path) && File.readable?(path)
        else
          true
        end
      end
      
      def writable?(path)
        unless File.writable?(path)
          begin
            FileUtils.touch(path)
            true
          rescue
            false
          end
        else
          true
        end
      end
    end
  end
end