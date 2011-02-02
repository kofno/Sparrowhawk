require 'builder'

module Sparrowhawk
  class WebXmlEntry
    attr_reader :name

    def initialize *args
      @name = "WEB-INF/web.xml"
    end

    def content
      raise NotImplementedError, "#content should be implemented in a subclass"
    end

    private

    def web_app
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml << doctype_declaration
      xml.tag! 'web-app' do |xml|
        yield xml if block_given?
      end
      xml
    end

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

    def public_root
      context_param('public.root', '/')
    end

    def doctype_declaration
      xml = Builder::XmlMarkup.new
      xml.declare!(:DOCTYPE, 'web-app'.to_sym, :PUBLIC,
                   "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN",
                   "http://java.sun.com/dtd/web-app_2_3.dtd")
      xml.target!
    end

    def rack_filter
      filter(:name  => 'RackFilter',
             :class => 'org.jruby.rack.RackFilter',
             :url   => '/*')
    end
  end
end
