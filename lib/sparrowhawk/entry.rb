module Sparrowhawk

  class Entry
    attr_reader :name, :content

    def initialize name, content
      @name = name
      @content = content
    end

  end

end
