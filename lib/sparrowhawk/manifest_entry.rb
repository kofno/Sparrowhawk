module Sparrowhawk

  class ManifestEntry
    attr_reader :name

    def initialize
      @name = 'META-INF/MANIFEST.MF'
    end

    def content
      %Q{Manifest-Version: 1.0\nCreated-By: #{Sparrowhawk::VERSION} (Sparrowhawk)}
    end
  end

end
