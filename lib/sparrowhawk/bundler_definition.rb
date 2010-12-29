require 'delegate'

module Sparrowhawk

  class BundlerDefinition < DelegateClass(::Bundler::Definition)
    def initialize
      super ::Bundler::Definition.build('Gemfile', 'Gemfile.lock', nil)
    end

    # Filters dependencies based on what should be in the war at runtime
    def runtime_dependencies
      dependencies.select do |dep|
        dep.type.to_sym == :runtime and
          (dep.platforms.empty? or dep.platforms.include?(:jruby)) and
          !(dep.groups & [:default, :production]).empty?
      end
    end
  end

end
