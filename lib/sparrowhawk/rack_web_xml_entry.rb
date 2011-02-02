module Sparrowhawk
  class RackWebXmlEntry < WebXmlEntry
    def initialize options={}
      super
      @rackup_file = options[:rackup]
    end

    def content
      web_app do |xml|
        xml << public_root
        xml << context_param('rackup', rackup) if rackup?
        xml << rack_filter
        xml << listener('org.jruby.rack.RackServletContextListener')
      end.target!
    end

    def rackup
      @rackup ||= IO.read(@rackup_file)
    end

    def rackup?
      @rackup_file && File.exists?(@rackup_file)
    end
  end
end
