module Sparrowhawk

  class GemMapper
    include Enumerable

    attr_reader :gems

    def initialize gems
      @gems = gems
    end

    def each
      gems.each do |gem|
        spec = gem.spec
        yield spec_entry spec.spec_name, spec.to_ruby

        gem.file_entries.each do |file_entry|
          yield gem_file_entry spec.full_name, file_entry[0]["path"], file_entry[1]
        end
      end
    end

    private

    def spec_entry spec_name, content
      Entry.new spec_prefix(spec_name), content
    end

    def spec_prefix basename
      File.join "WEB-INF/gems/specifications", basename
    end

    def gem_file_entry gem_name, basename, content
      Entry.new gem_file_prefix(gem_name, basename), content
    end

    def gem_file_prefix gem_name, file_name
      File.join "WEB-INF/gems/gems", gem_name, file_name
    end

  end

end
