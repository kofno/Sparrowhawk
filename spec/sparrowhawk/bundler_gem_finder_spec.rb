require 'spec_helper'

module Sparrowhawk

  describe BundlerGemFinder do
    let(:finder) do
      definition = BundlerDefinition.new 'Gemfile', 'Gemfile.lock'
      BundlerGemFinder.new definition
    end

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
       gem 'logging', :group => :production
       gem 'rspec', :groups => [:test, :development]
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

    context "when gem home is not set" do
      before do
        @old_gem_home = ENV['GEM_HOME']
        ENV['GEM_HOME'] = nil
      end

      after do
        ENV['GEM_HOME'] = @old_gem_home
      end

      it "returns bundler gem from the bundle path, if gem home is not set" do
        in_current_dir do
          finder.map(&:gem_path).should include(Bundler.bundle_path.to_s + "/cache/bundler-1.0.7.gem")
        end
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

    it "does not return mri specific platform gems" do
      in_current_dir do
        finder.map(&:gem_path).should_not include('vendor/cache/pg-0.9.0.gem')
      end
    end

    it "returns gems from the :production group" do
      in_current_dir do
        finder.map(&:gem_path).should include('vendor/cache/logging-1.4.3.gem')
      end
    end

    it "exludes gems that aren't part of the :production or :default groups" do
      in_current_dir do
        finder.map(&:gem_path).should_not include('vendor/cache/rspec-2.2.0.gem')
      end
    end
  end

end
