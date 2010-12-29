module Sparrowhawk

  class Configuration

    #Sets the name/file path of the war file. Ex: ../distro/example.war
    attr_accessor :war_file

    #Sets the base directories that will be scanned for application
    #files (not static content). Some directories will always be
    #excluded implicitly (e.g. vendor/cache)
    attr_accessor :application_dirs

    #The min and max runtimes that will be used to service
    #requests. Accepts a range.
    attr_accessor :runtimes

    #Which environment to use when running the application
    attr_accessor :environment

    #Other files to include in the application code (LICENSE, README, etc.)
    attr_accessor :other_files

    #Returns an object instance that can be used to build a war
    def war
      war = War.new war_file
      war.entries << PublicDirMapper.new.to_a
      war.entries << WebXmlEntry.new(web_xml_options)
      war.entries << ManifestEntry.new
      war.entries << ApplicationFilesMapper.new(application_dirs).to_a
      war.entries << JRubyCoreJarEntry.new
      war.entries << JRubyStdLibJarEntry.new
      war.entries << JRubyRackJarEntry.new
      gem_finder = BundlerGemFinder.new
      war.entries << GemMapper.new(gem_finder).to_a
      war.entries << GemfileEntry.new
      war.entries << LockfileEntry.new
      other_files.each do |file|
        war.entries << FileEntry.new("WEB-INF/#{file}", file)
      end if other_files
      war
    end

    def initialize
      yield self if block_given?
    end

    private

    def web_xml_options
      options = {}
      options[:runtimes] = runtimes if runtimes
      options[:environment] = environment if environment
      options
    end

  end

end
