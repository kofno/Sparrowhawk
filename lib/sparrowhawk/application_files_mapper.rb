module Sparrowhawk

  class ApplicationFilesMapper
    include FileEntryMapper

    attr_reader :application_dir

    def initialize
      @application_dir = expand_path '.'
      @excluded_path_patterns = [%r{/vendor/cache/}]
    end

    private

    def file_pattern
      application_dir + "/{app,config,lib,vendor}/**{,/*/**}/*"
    end

    def entry_name file_name
      "WEB-INF/" + expand_path(file_name)[application_dir.length + 1..-1]
    end

  end

end
