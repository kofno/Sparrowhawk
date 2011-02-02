module Sparrowhawk

  class Configuration

    # Sets the name/file path of the war file. Ex: ../distro/example.war
    attr_accessor :war_file

    # Sets the base directories that will be scanned for application
    # files (not static content). Some directories will always be
    # excluded implicitly (e.g. vendor/cache)
    attr_accessor :application_dirs

    # The min and max runtimes that will be used to service
    # rails requests. Accepts a range. Only applies to rails
    attr_accessor :runtimes

    # Which environment to use when running the application. Only applies to rails.
    attr_accessor :environment

    # Other files to include in the application code (LICENSE, README, etc.)
    attr_accessor :other_files

    # Set the rack config file. Defaults to 'config.ru'
    attr_accessor :rack_config

    # Returns an object instance that can be used to build a war
    def war
      war = War.new war_file
      war.entries += public_dir_entries
      war.entries << web_xml_entry
      war.entries << manifest_entry
      war.entries += application_file_entries
      war.entries << jruby_core_jar_entry
      war.entries << jruby_std_jar_entry
      war.entries << jruby_rack_jar_entry
      war.entries += gem_entries
      other_files.each do |file|
        war.entries << file_entry("WEB-INF/#{file}", file)
      end if other_files
      war
    end

    def initialize
      @rack_config = default_rack_config
      yield self if block_given?
    end

    def rack_app?
      File.file? File.expand_path(rack_config)
    end

    private

    def manifest_entry
      @manifest_entry ||= ManifestEntry.new
    end

    def public_dir_entries
      @public_dir_entries ||= PublicDirMapper.new.to_a
    end

    def application_file_entries
      @application_file_entries ||= ApplicationFilesMapper.new(application_dirs).to_a
    end

    def jruby_core_jar_entry
      @jruby_core_jar_entry ||= JRubyCoreJarEntry.new
    end

    def jruby_std_jar_entry
      @jruby_std_jar_entry ||= JRubyCoreJarEntry.new
    end

    def jruby_rack_jar_entry
      @jruby_rack_jar_entry ||= JRubyRackJarEntry.new
    end

    def gem_entries
      @gem_entries ||= BundlerArtifactMapper.new.to_a
    end

    def file_entry entry_name, path
      FileEntry.new entry_name, path
    end

    def web_xml_entry
      @web_xml_entry ||= (rack_app? ? 
        RackWebXmlEntry.new(:rackup => rack_config) :
        RailsWebXmlEntry.new(rails_web_xml_options))
    end

    def rails_web_xml_options
      options = {}
      options[:runtimes] = runtimes if runtimes
      options[:environment] = environment if environment
      options
    end

    def default_rack_config
      './config.ru'
    end
  end

end
