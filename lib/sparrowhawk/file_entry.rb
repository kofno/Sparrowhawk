module Sparrowhawk

  class FileEntry

    attr_reader :name, :source

    def initialize entry_name, file_name
      @name = entry_name
      @source = file_name
    end

    def content
      @content ||= IO.read(source)
    end

  end
end
