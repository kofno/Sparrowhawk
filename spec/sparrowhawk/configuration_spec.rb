require 'spec_helper'

module Sparrowhawk

  describe Configuration do
    let(:config) { Configuration.new }

    before do
      FileUtils.rm_rf current_dir

      create_file "Gemfile", <<-GEMFILE
        source :gemcutter
        gem 'nokogiri'
      GEMFILE

      create_file "Gemfile.lock", <<-LOCK
GEM
  remote: http://rubygems.org/
  specs:
    nokogiri (1.4.3.1)
    nokogiri (1.4.3.1-java)
      weakling (>= 0.0.3)


PLATFORMS
  java
  ruby

DEPENDENCIES
  nokogiri
       LOCK

    end

    it "returns a war builder based on the configuration" do
      in_current_dir do
        config.war_file = 'example.war'
        config.application_dirs = %w(app config vendor db)
        config.runtimes = 1..5
        config.environment = 'development'
        config.other_files = Dir['LICENSE']
        config.war.build.should exist
      end
    end

  end
end
