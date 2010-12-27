require 'spec_helper'

module Sparrowhawk

  describe BundlerGemFinder do
    let(:finder) { BundlerGemFinder.new "Gemfile.lock" }

    before do
      FileUtils.rm_rf current_dir
      create_file "Gemfile.lock", <<-LOCK
GEM
  remote: http://rubygems.org/
  specs:
    activerecord-jdbc-adapter (1.1.0)
    nokogiri (1.4.3.1)
    nokogiri (1.4.3.1-java)
      weakling (>= 0.0.3)

PLATFORMS
  java
  ruby

DEPENDENCIES
  activerecord-jdbc-adapter
  nokogiri
       LOCK

      create_file "Gemfile", <<-GEMFILE
       source :gemcutter
       platform :jruby do
         gem 'activerecord-jdbc-adapter'
       end
       gem 'nokogiri'
       GEMFILE

      in_current_dir do
        FileUtils.mkdir_p 'vendor/cache'
        FileUtils.cp Dir.glob('../../spec/fixtures/*.gem'), 'vendor/cache'
      end
    end

    it "returns default gems from vendor cache that are appropriate for the java platform" do
      in_current_dir do
        finder.map(&:gem_path).should include(ENV['GEM_HOME'] + "/cache/bundler-1.0.7.gem")
        finder.map(&:gem_path).should include('vendor/cache/weakling-0.0.4-java.gem')
        finder.map(&:gem_path).should include('vendor/cache/nokogiri-1.4.3.1-java.gem')
      end
    end

    it "returns only runtime dependencies" do
      in_current_dir do
        finder.map(&:gem_path).should_not include('vendor/cache/hoe-2.8.0.gem')
      end
    end

    it "returns jruby platform gems" do
      in_current_dir do
        finder.map(&:gem_path).should include('vendor/cache/activerecord-jdbc-adapter-1.1.0.gem')
      end
    end
  end

end
