module Sparrowhawk

  class LockfileEntry < FileEntry

    def initialize
      super "WEB-INF/Gemfile.lock", "Gemfile.lock"
    end

  end

end
