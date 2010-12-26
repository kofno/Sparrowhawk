module Sparrowhawk

  # Needed a bundler index can search for gems on the java platform,
  # regardless of what platform you are cuurrently on.
  class Index < ::Bundler::Index

    def << spec
      super
      arr = @specs[spec.name]
      if arr.any? { |s| s.platform == java_platform }
        arr.delete_if { |s| s.platform != java_platform }
      end
    end

    private

    def search_by_dependency dependency
      @cache[dependency.hash] ||= begin
        specs = @specs[dependency.name]

        wants_prerelease = dependency.requirement.prerelease?
        only_prerelease  = specs.all? {|spec| spec.version.prerelease? }
        found = specs.select { |spec| dependency.matches_spec?(spec) && matches_java_platform?(spec.platform) }

        unless wants_prerelease || only_prerelease
          found.reject! { |spec| spec.version.prerelease? }
        end

        found.sort_by {|s| [s.version, s.platform.to_s == 'ruby' ? "\0" : s.platform.to_s] }
      end
    end

    def matches_java_platform? platform
      ["ruby", java_platform].any? do |java_platform|
        platform.nil? or java_platform == platform or
          (java_platform != Gem::Platform::RUBY and java_platform =~ platform)
      end
    end

    def java_platform
      @java_platform ||= Gem::Platform.new("java")
    end
  end
end
