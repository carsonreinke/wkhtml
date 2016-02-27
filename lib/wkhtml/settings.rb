module WkHtml
  module Settings
    TRUE = 'true'
    FALSE = 'false'

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(initial = {})
      initial = self.class.default_settings.merge(initial)
      initial.each{|key,value| self[key] = value}
    end

    #
    # Convert all attributes to Hash.  This will ignore errors from retrieving
    # the setting.
    #
    def to_hash()
      Hash[
        self.class.settings.map do |key|
          begin
            [key, self[key]]
          rescue ArgumentError
            nil
          end
        end.compact()
      ]
    end
    alias_method :to_h, :to_hash


    module ClassMethods
      #
      # List of settings defined
      #
      def settings()
        @settings ||= []
      end

      #
      # Assign the attributes and define instance methods
      #
      def settings=(keys)
        @settings = keys
        keys.each do |key|
          #Change key to local method
          local_key = key.tr('.', '_')

          #Getter
          define_method(local_key.to_sym()) do
            self[key]
          end unless method_defined?(local_key.to_sym())

          #Setter
          define_method(:"#{local_key}=") do |value|
            self[key] = value
          end unless method_defined?(:"#{local_key}=")
        end
      end

      #
      # List of default attibute values
      #
      def default_settings()
        @default_settings ||= {}
      end

      #
      # Assign default attributes that will be set when created
      #
      def default_settings=(hash)
        @default_settings = hash
      end
    end
  end
end