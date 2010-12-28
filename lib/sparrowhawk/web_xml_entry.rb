require 'builder'

module Sparrowhawk

  class WebXmlEntry
    attr_reader :name, :environment

    def initialize options={}
      @name = 'WEB-INF/web.xml'
      @runtimes = options[:runtimes] || (1..1)
      @environment = options[:environment] || 'development'
    end

    def content
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.declare!(:DOCTYPE, 'web-app'.to_sym, :PUBLIC,
                   "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN",
                   "http://java.sun.com/dtd/web-app_2_3.dtd")
      xml.tag! 'web-app' do |xml|
        xml << context_param('rails.env', environment)
        xml << context_param('public.root', '/')
        xml << context_param('jruby.min.runtimes', min_runtimes)
        xml << context_param('jruby.max.runtimes', max_runtimes)
        xml << filter(:name  => 'RackFilter',
                      :class => 'org.jruby.rack.RackFilter',
                      :url   => '/*')
        xml << listener('org.jruby.rack.rails.RailsServletContextListener')
      end
      xml.target!
    end

    def max_runtimes
      @runtimes.end.to_s
    end

    def min_runtimes
      @runtimes.begin.to_s
    end

    private

    def context_param name, value
      xml = Builder::XmlMarkup.new
      xml.tag! 'context-param' do |xml|
        xml.tag! 'param-name', name
        xml.tag! 'param-value', value
      end
      xml.target!
    end

    def filter options
      xml = Builder::XmlMarkup.new
      xml.filter do |xml|
        xml.tag! 'filter-name', options[:name]
        xml.tag! 'filter-class', options[:class]
      end
      xml.tag! 'filter-mapping' do |xml|
        xml.tag! 'filter-name', options[:name]
        xml.tag! 'url-pattern', options[:url]
      end
      xml.target!
    end

    def listener clazz
      xml = Builder::XmlMarkup.new
      xml.listener do |xml|
        xml.tag! 'listener-class', clazz
      end
      xml.target!
    end

  end

end
