module Sparrowhawk

  class RailsWebXmlEntry < WebXmlEntry
    attr_reader :name, :environment

    def initialize options={}
      super
      @runtimes = options[:runtimes] || (1..1)
      @environment = options[:environment] || 'development'
    end

    def content
      web_app do |xml|
        xml << context_param('rails.env', environment)
        xml << public_root
        xml << context_param('jruby.min.runtimes', min_runtimes)
        xml << context_param('jruby.max.runtimes', max_runtimes)
        xml << rack_filter
        xml << listener('org.jruby.rack.rails.RailsServletContextListener')
      end.target!
    end

    def max_runtimes
      @runtimes.end.to_s
    end

    def min_runtimes
      @runtimes.begin.to_s
    end

  end

end
