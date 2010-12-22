require 'spec_helper'

module Sparrowhawk

  describe JRubyRackJarEntry do
    let(:entry) { JRubyRackJarEntry.new }

    context '#name' do
      it "should be 'WEB-INF/lib/jruby-rack-<jruby-rack-version>.jar'" do
        entry.name.should == "WEB-INF/lib/jruby-rack-#{JRuby::Rack::VERSION}.jar"
      end
    end

    context '#source' do
      it "should exist" do
        File.exists?(entry.source).should be_true
      end
    end
  end
end
