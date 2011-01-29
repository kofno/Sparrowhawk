require 'zip/zipfilesystem'

module Sparrowhawk

  class War

    attr_reader :name
    attr_accessor :entries

    def initialize file_name=nil
      @name = file_name || default_file_name
      @entries = []
    end

    def exist?
      File.exist? name
    end
    alias exists? exist?

    def has_entry? entry_name
      return false unless exists?
      open_war { |zip| zip.file.exists?(entry_name) }
    end

    def build
      open_war for_writing do |zip|
        entries.flatten.each do |entry|
          zip.file.open(entry.name, "w") { |f| f << entry.content }
        end
      end
      self
    end

    private

    def open_war for_writing=nil, &block
      Zip::ZipFile.open name, for_writing, &block
    end

    def for_writing
      Zip::ZipFile::CREATE
    end

    def default_file_name
      "#{File.basename File.expand_path('.')}.war"
    end
  end

end
