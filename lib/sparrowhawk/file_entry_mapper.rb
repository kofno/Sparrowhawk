module Sparrowhawk
  module FileEntryMapper
    include Enumerable

    def each
      file_entry_tuples.each do |entry_name, file_path|
        next if File.directory? file_path
        next if excluded? file_path
        yield FileEntry.new entry_name, file_path
      end
    end

    def file_entry_tuples
      Dir.glob(file_pattern).uniq.map do |f|
        [entry_name(f), expand_path(f)]
      end
    end

    def expand_path file_name
      File.expand_path file_name
    end

    def excluded? file_path
      excluded_path_patterns.any? { |pattern| pattern =~ file_path }
    end

    def excluded_path_patterns
      @excluded_path_patterns ||= []
    end
  end
end
