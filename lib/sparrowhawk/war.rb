require 'zip/zipfilesystem'

module Sparrowhawk

  class War

    class << self

      def build
        war = new
        war.entries << PublicDirMapper.new.to_a
        war.entries << WebXmlEntry.new
        war.entries << ManifestEntry.new
        war.entries << ApplicationFilesMapper.new.to_a
        war.entries << JRubyCoreJarEntry.new
        war.entries << JRubyStdLibJarEntry.new
        war.entries << JRubyRackJarEntry.new
        gem_finder = BundlerGemFinder.new ::Bundler.default_lockfile
        war.entries << GemMapper.new(gem_finder).to_a
        war.entries << GemfileEntry.new
        war.entries << LockfileEntry.new
        war.build
      end
    end

    attr_reader :name, :entries

    def initialize
      @name = "#{File.basename File.expand_path('.')}.war"
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
  end

end
