require 'spec_helper'

module Sparrowhawk

  describe JRubyStdLibJarEntry do
    let(:entry) { JRubyStdLibJarEntry.new }

    context '#name' do
      it "should be 'WEB-INF/lib/jruby--<jruby-version>.jar'" do
        entry.name.should == "WEB-INF/lib/jruby-stdlib-#{JRubyJars::VERSION}.jar"
      end
    end

    context '#source' do
      it "should exist" do
        File.exists?(entry.source).should be_true
      end
    end
  end
end
