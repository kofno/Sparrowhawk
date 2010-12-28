require 'spec_helper'

module Sparrowhawk

  describe BundlerDefinition, "which only cares about JRuby runtimes" do
    let(:definition) { BundlerDefinition.new }

    before do
      FileUtils.rm_rf current_dir
      create_file "Gemfile.lock", <<-LOCK
GEM
  remote: http://rubygems.org/
  specs:
    activerecord-jdbc-adapter (1.1.0)
    pg (0.9.0)
    nokogiri (1.4.3.1)
    nokogiri (1.4.3.1-java)
      weakling (>= 0.0.3)


PLATFORMS
  java
  ruby

DEPENDENCIES
  activerecord-jdbc-adapter
  pg
  nokogiri
       LOCK

      create_file "Gemfile", <<-GEMFILE
       source :gemcutter
       platform :jruby do
         gem 'activerecord-jdbc-adapter'
       end
       platform :ruby_18, :ruby_19 do
         gem 'pg'
       end
       gem 'nokogiri'
       GEMFILE
    end

    it "should not return deps specific to :ruby platforms" do
      in_current_dir do
        definition.runtime_dependencies.map(&:name).should_not include('pg')
      end
    end

    it "should include dependencies specific to the :java platform" do
      in_current_dir do
        definition.runtime_dependencies.map(&:name).should include('activerecord-jdbc-adapter')
      end
    end

    it "should include dependencies that don't have an explicit platform" do
      in_current_dir do
        definition.runtime_dependencies.map(&:name).should include('nokogiri')
      end
    end

  end
end
