require 'rake/tasklib'
require 'sparrowhawk'

module Sparrowhawk

  class RakeTask < ::Rake::TaskLib

    def initialize task_name=:war, &block
      @configuration = Configuration.new &block

      task task_name do
        @configuration.war.build
      end
    end

  end

end
