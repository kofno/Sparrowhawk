require 'spec_helper'

module Sparrowhawk

  describe BundlerArtifactMapper do
    let(:mapper) { BundlerArtifactMapper.new }

    before do
      FileUtils.rm_rf current_dir

      write_file "Gemfile", <<-GEMFILE
        source :gemcutter
        gem 'logger', :groups => :production
        gem 'rspec', :groups => [:test, :development]
        GEMFILE
    end

    it "includes a gemfile entry" do
      in_current_dir do
        mapper.map(&:name).should include("WEB-INF/Gemfile")
      end
    end

    it "includes a lockfile entry" do
      in_current_dir do
        mapper.map(&:name).should include("WEB-INF/Gemfile.lock")
      end
    end
    
    it "includes bundled gems" do
      in_current_dir do
        mapper.map(&:name).should include_match(%r{WEB-INF/gems/specifications/bundler-\d\.\d\.\d\.gemspec})
      end
    end

    it "includes a local bundler configuration" do
      mapper.map(&:name).should include("WEB-INF/.bundle/config")
    end
  end

end
