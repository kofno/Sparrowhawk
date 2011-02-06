require 'spec_helper'

module Sparrowhawk
  describe RackWebXmlEntry do
    let(:entry) { RackWebXmlEntry.new }

    it "should be named" do
      entry.name.should == "WEB-INF/web.xml"
    end

    context "content" do
      let(:entry) { RackWebXmlEntry.new :rackup => 'config.ru' }

      before do
        @rackup = <<-RACKUP
          require 'rubygems'
          require 'bundler'
         
          Bundler.require
          gem 'boo', '>= 2.0' 
          require 'list'
          run Sinatra::Application
        RACKUP
        write_file 'config.ru', @rackup
      end

      it "should store the rackup file in the rackup context param" do
        in_current_dir do
          entry.content.context_param_value('rackup').text.should == @rackup
        end
      end

      it "should set public root to the base of the war (/)" do
        in_current_dir do
          entry.content.should have_context_param('public.root', '/')
        end
      end

      it "should set up the rack filter" do
        entry.content.should have_filter(:name  => 'RackFilter',
                                         :class => 'org.jruby.rack.RackFilter',
                                         :url   => '/*')
      end

      it "should set up the rack servlet context listener" do
        in_current_dir do
          entry.content.should have_css("web-app listener listener-class:content('org.jruby.rack.RackServletContextListener')")
        end
      end

      it "should be valid xml" do
        in_current_dir do
          entry.content.should be_valid_xml
        end
      end
    end
  end
end
