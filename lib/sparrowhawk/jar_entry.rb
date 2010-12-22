module Sparrowhawk

  class JarEntry < FileEntry

    def initialize
      super jar_entry_name, jar_path
    end

    def jar_entry_name
      "WEB-INF/lib/#{File.basename(jar_path)}"
    end

    def jar_path
      raise NotImplementedError, "#jar_path should be implemented by a subclass"
    end
  end

end
