require 'rake/tasklib'
require 'sparrowhawk'

module Sparrowhawk

  class RakeTask < ::Rake::TaskLib

    attr_accessor :war_file

    attr_accessor :application_dirs

    attr_accessor :runtimes

    attr_accessor :environment

    attr_accessor :other_files

    def initialize task_name=:war
      yield self if block_given?

      task task_name do
        war.build
      end
    end

    private

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

    def web_xml_options
      options = {}
      options[:runtimes] = runtimes if runtimes
      options[:environment] = environment if environment
      options
    end

  end

end
