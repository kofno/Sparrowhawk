require 'spec_helper'

module Sparrowhawk

  describe BundlerConfigurationEntry do
    let(:entry) { BundlerConfigurationEntry.new :without => [:cli, :uat, :test, :development] }

    it "creates an entry named WEB-INF/.bundle/config" do
      entry.name.should == 'WEB-INF/.bundle/config'
    end

    it "sets the list of gem groups that should *not* be loaded by the war app" do
      YAML::load(entry.content).should == { 'BUNDLE_WITHOUT' => 'cli:uat:test:development' }
    end

  end
end
