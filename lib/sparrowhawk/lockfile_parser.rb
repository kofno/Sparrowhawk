module Sparrowhawk

  class LockfileParser < ::Bundler::LockfileParser
    alias runtime_dependencies dependencies
  end

end
