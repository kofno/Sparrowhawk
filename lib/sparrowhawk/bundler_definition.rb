require 'delegate'

module Sparrowhawk

  class BundlerDefinition < DelegateClass(::Bundler::Definition)

    def initialize gemfile, lockfile
      super ::Bundler::Definition.build(gemfile, lockfile, nil)
    end

    # Filters dependencies based on what should be in the war at runtime
    def runtime_dependencies
      dependencies.select do |dep|
        dep.type.to_sym == :runtime and
          (dep.platforms.empty? or dep.platforms.include?(:jruby)) and
          !(dep.groups & production_groups).empty?
      end
    end

    def excluded_groups
      @excluded_groups ||= groups - production_groups
    end

    def production_groups
      [:default, :production]
    end
  end

end
