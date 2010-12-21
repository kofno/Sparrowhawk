module Sparrowhawk

  class PublicDirMapper
    include Enumerable

    attr_reader :public_dir

    def initialize
      @public_dir = expand_path('./public')
    end

    def each
      file_entry_tuples.each do |entry_name, file_path|
        yield FileEntry.new entry_name, file_path
      end
    end

    private

    def file_entry_tuples
      Dir.glob(public_dir + "/**/*").map do |f|
        [entry_name(f), expand_path(f)]
      end
    end

    def entry_name file_name
      expand_path(file_name)[public_dir.length + 1..-1 ]
    end

    def expand_path file_name
      File.expand_path file_name
    end
  end

end
