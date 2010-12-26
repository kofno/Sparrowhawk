module Sparrowhawk

  class GemfileEntry < FileEntry
    def initialize
      super "WEB-INF/Gemfile", "Gemfile"
    end
  end

end
