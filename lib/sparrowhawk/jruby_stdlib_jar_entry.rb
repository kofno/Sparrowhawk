require 'jruby-jars'

module Sparrowhawk

  class JRubyStdLibJarEntry < JarEntry

    def jar_path
      JRubyJars.stdlib_jar_path
    end
  end

end
