require 'delegate'

module Sparrowhawk

  class BundlerDefinition < DelegateClass(::Bundler::Definition)
    def initialize
      super ::Bundler::Definition.build('Gemfile', 'Gemfile.lock', nil)
    end

    def runtime_dependencies
      dependencies.select do |dep|
        dep.type.to_sym == :runtime and
          (dep.platforms.empty? or dep.platforms.include?(:jruby))
      end
    end
  end

end
