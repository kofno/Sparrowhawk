require 'spec_helper'

module Sparrowhawk

  describe JRubyCoreJarEntry do
    let(:entry) { JRubyCoreJarEntry.new }

    context '#name' do
      it "should be 'WEB-INF/lib/jruby-core-<jruby-version>.jar'" do
        entry.name.should == "WEB-INF/lib/jruby-core-#{JRubyJars::VERSION}.jar"
      end
    end

    context '#source' do
      it "should exist" do
        File.exists?(entry.source).should be_true
      end
    end
  end
end
