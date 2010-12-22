require 'jruby-jars'

module Sparrowhawk

  class JRubyCoreJarEntry < JarEntry

    def jar_path
      JRubyJars.core_jar_path
    end
  end

end
