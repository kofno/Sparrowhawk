require 'nokogiri'

module Sparrowhawk
  class PseudoClasses
    def content node_set, text
      node_set.find_all { |node| node.text == text }
    end
  end

  class << self
    def pseudo_classes
      @pseudo_classes ||= PseudoClasses.new
    end

    def xmllint?
      system "which xmllint"
    end
  end
end

class String
  if Sparrowhawk.xmllint?
    def valid_xml?
      # a bit chatty
      IO.popen('xmllint --valid -', 'w') { |f| f.puts self }
      $?.success?
    end
  else
    def valid_xml?
      $stderr.puts "xmllint is missing: skipping validation checks"
      true
    end
  end

  def context_param_value param_name
    document = Nokogiri::XML(self)
    document.xpath("/web-app/context-param/param-name[text()='#{param_name}']/../param-value")
  end
end

RSpec::Matchers.define :have_css do |pattern|
  match do |xml|
    document = Nokogiri::XML(xml)
    document.css(pattern, Sparrowhawk.pseudo_classes).size > 0
  end
end

RSpec::Matchers.define :have_context_param do |name, value|
  match do |xml|
    document = Nokogiri::XML(xml)
    document.xpath("/web-app/context-param/param-name[text()='#{name}']/../param-value[text()='#{value}']").size > 0
  end
end

RSpec::Matchers.define :have_filter do |options|
  match do |xml|
    document = Nokogiri::XML(xml)
    filter_matches?(document, options) && filter_mapping_matches?(document, options)
  end

  def filter_matches? xml, options
    xml.xpath("/web-app/filter/filter-name[text()='#{options[:name]}']/../filter-class[text()='#{options[:class]}']").size > 0
  end

  def filter_mapping_matches? xml, options
    xml.xpath("/web-app/filter-mapping/filter-name[text()='#{options[:name]}']/../url-pattern[text()='#{options[:url]}']").size > 0
  end
end

RSpec::Matchers.define :include_match do |regexp|
  match do |enum|
    enum.any? { |value| regexp =~ value }
  end
end
