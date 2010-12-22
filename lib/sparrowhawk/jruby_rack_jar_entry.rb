require 'jruby-rack'

module Sparrowhawk

  class JRubyRackJarEntry < JarEntry
    def jar_path
      JRubyJars.jruby_rack_jar_path
    end
  end

end
