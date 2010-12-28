module Sparrowhawk

  class JRubyRackJarEntry < JarEntry

    def jar_path
      return @jar_path if @jar_path
      begin
        require 'jruby-rack'
        @jar_path = JRubyJars.jruby_rack_jar_path
      rescue LoadError => err
        @jar_path = jar_path_from_load_error(err)
      end
    end

    private

    def jar_path_from_load_error err
      @jar_path = err.message.split(' -- ')[1]
    end
  end

end
