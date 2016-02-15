module WkHtml
  module Settings
    TRUE = 'true'
    FALSE = 'false'
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    #http://wkhtmltopdf.org/libwkhtmltox/pagesettings.html
    
    def to_hash()
      #TODO
    end
    
    module ClassMethods
      def define_attributes(keys)
        keys.each do |key|
          local_key = underscore(key)
          local_key.tr!('.', '_')
          
          define_method(local_key.to_sym()) do
            self[key]
          end unless method_defined?(local_key.to_sym())
          
          define_method(:"#{local_key}=") do |value|
            self[key] = value
          end unless method_defined?(:"#{local_key}=")
        end
      end


    private
      #Copied from ActiveSupport::Inflector
      def underscore(word)
        word = word.to_s().dup()
        word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)((?=a)b)(?=\b|[^a-z])/) { "#{$1 && '_'}#{$2.downcase}" }
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end
    end
  end
end