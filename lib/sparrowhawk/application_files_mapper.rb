module Sparrowhawk

  class ApplicationFilesMapper
    include FileEntryMapper

    attr_reader :application_root, :application_dirs

    def initialize application_dirs=nil
      @application_root = expand_path '.'
      @excluded_path_patterns = [%r{/vendor/cache/}]
      @application_dirs = application_dirs || default_application_dirs
    end

    private

    def file_pattern
      application_root + "/{#{application_dirs.join(',')}}/**{,/*/**}/*"
    end

    def entry_name file_name
      "WEB-INF/" + expand_path(file_name)[application_root.length + 1..-1]
    end

    def default_application_dirs
      %w(app config lib vendor)
    end

  end

end
