module Sparrowhawk

  class BundlerArtifactMapper
    include Enumerable
    
    attr_reader :definition

    def initialize
      @definition = BundlerDefinition.new gemfile, lockfile
    end

    def each
      entries.each { |entry| yield entry }
    end

    private

    def entries
      return @entries if @entries
      @entries = []
      @entries << GemfileEntry.new
      @entries << LockfileEntry.new
      @entries << gems
      unless groups.empty?
        @entries << bundler_configuration
      end
      @entries.flatten
    end

    def gems
      unless @gems
        gem_finder = BundlerGemFinder.new definition
        @gems = GemMapper.new(gem_finder).to_a.flatten
      end
      @gems
    end

    def groups
      @groups ||= definition.groups or []
    end

    def bundler_configuration
      @bundler_configuration ||= BundlerConfigurationEntry.new :without => excluded_groups
    end

    def excluded_groups
      definition.excluded_groups
    end

    def gemfile
      'Gemfile'
    end

    def lockfile
      'Gemfile.lock'
    end
  end

end
