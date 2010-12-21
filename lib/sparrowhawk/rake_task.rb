require 'rake/tasklib'
require 'sparrowhawk'

module Sparrowhawk

  class RakeTask < ::Rake::TaskLib

    def initialize
      task :war do
        War.build
      end
    end
  end

end
