module Sparrowhawk

  class BundlerGemFinder
    include Enumerable

    attr_reader :definition

    def initialize lockfile
      @lockfile = Bundler::LockfileParser.new IO.read(lockfile)
    end

    def each
      gems.each { |g| yield g }
    end

    private

    def specs
      specs_for_dependencies_of @lockfile
    end

    def gems
      @gems ||= [bundler_gem] + specs.map { |s| gem_from_file_by_path(s.source) }
    end

    def vendor_cache
      @vendor_cache ||= Index.build do |idx|
        Dir['vendor/cache/*.gem'].each do |gemfile|
          spec ||= Gem::Format.from_file_by_path(gemfile).spec
          idx << spec
          spec.source = gemfile
        end
      end
    end

    def specs_for_dependencies_of thing
      thing.dependencies.map do |dep|
        specs = vendor_cache.search(dep)
        specs.map { |s| specs_for_dependencies_of s } + specs
      end.flatten
    end

    def bundler_gem
      gem_from_file_by_path cached_bundler_gem_path
    end

    def cached_bundler_gem_path
      File.join ENV['GEM_HOME'], "cache", "bundler-#{::Bundler::VERSION}.gem"
    end

    def gem_from_file_by_path path
      Gem::Format.from_file_by_path path
    end
  end

end
