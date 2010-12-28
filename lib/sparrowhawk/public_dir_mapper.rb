module Sparrowhawk

  class PublicDirMapper
    include FileEntryMapper

    attr_reader :public_dir

    def initialize
      @public_dir = expand_path('./public')
      @excluded_path_patterns = [%r{.*\.sass$}]
    end

    private

    def file_pattern
      public_dir + "/**{,/*/**}/*"
    end

    def entry_name file_name
      expand_path(file_name)[public_dir.length + 1..-1 ]
    end
  end

end
