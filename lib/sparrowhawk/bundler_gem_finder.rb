module Sparrowhawk

  class BundlerGemFinder
    include Enumerable

    attr_reader :definition

    def initialize definition
      @definition = definition 
    end

    def each
      gems.each { |g| yield g }
    end

    private

    def specs
      specs_for_dependencies_of @definition
    end

    def gems
      @gems ||= [bundler_gem] + specs.map { |s| gem_from_file_by_path(s.source) }
    end

    def vendor_cache
      @vendor_cache ||= Index.build do |idx|
        Dir['vendor/cache/*.gem'].each do |gemfile|
          spec ||= gem_from_file_by_path(gemfile).spec
          idx << spec
          spec.source = gemfile
        end
      end
    end

    def specs_for_dependencies_of def_or_dep
      def_or_dep.runtime_dependencies.map do |dep|
        specs = vendor_cache.search(dep)
        specs.map { |s| specs_for_dependencies_of s } + specs
      end.flatten
    end

    def bundler_gem
      gem_from_file_by_path cached_bundler_gem_path
    end

    def cached_bundler_gem_path
      File.join ENV['GEM_HOME'] || ::Bundler.bundle_path.to_s, "cache", "bundler-#{::Bundler::VERSION}.gem"
    end

    def gem_from_file_by_path path
      Gem::Format.from_file_by_path path
    end
  end

end
