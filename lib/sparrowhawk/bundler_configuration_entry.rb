module Sparrowhawk

  class BundlerConfigurationEntry
    attr_reader :name
    attr_reader :content

    def initialize options = {}
      @name = 'WEB-INF/.bundle/config'
      @content = config_yaml options
    end

    private

    def config_yaml options
      config = {}
      if options[:without]
        config['BUNDLE_WITHOUT'] = options[:without].join(':')
      end
      config.to_yaml
    end
  end

end
