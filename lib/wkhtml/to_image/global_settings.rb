module WkHtml
  module ToImage
    class GlobalSettings
      include Settings
      
      DEFAULTS = {:fmt => 'jpeg'}
      
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