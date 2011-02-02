require 'spec_helper'

module Sparrowhawk

  describe RailsWebXmlEntry do

    context 'by default' do
      let(:entry) { RailsWebXmlEntry.new }

      it "has the the entry name 'WEB-INF/web.xml'" do
        entry.name.should == 'WEB-INF/web.xml'
      end

      context 'content' do
        it "sets context param 'rails.env' to 'development'" do
          entry.content.should have_context_param('rails.env', 'development')
        end

        it "sets context param 'public.root', to '/'" do
          entry.content.should have_context_param('public.root', '/')
        end

        it "sets context param 'jruby.max.runtimes' to '1'" do
          entry.content.should have_context_param('jruby.max.runtimes', '1')
        end

        it "sets up a rack filter for jruby-rack" do
          entry.content.should have_filter(:name => 'RackFilter',
                                           :class => 'org.jruby.rack.RackFilter',
                                           :url => '/*')
        end

        it "sets up a listener for the rails servlet context" do
          entry.content.should have_css("web-app listener listener-class:content('org.jruby.rack.rails.RailsServletContextListener')")
        end

        it "should be valid" do
          entry.content.should be_valid_xml
        end
      end
    end

    context "configuring web.xml content" do
      let(:entry) do
        RailsWebXmlEntry.new({
          :runtimes => 1..5,
          :environment => 'production'
        })
      end

      it "sets the min runtimes to '1'" do
        entry.content.should have_context_param('jruby.min.runtimes', '1')
      end

      it "sets the max runtimes to '5'" do
        entry.content.should have_context_param('jruby.max.runtimes', '5')
      end

      it "sets the rails environment to 'production'" do
        entry.content.should have_context_param('rails.env', 'production')
      end

      it "should remain valid" do
        entry.content.should be_valid_xml
      end
    end

  end

end
