require 'spec_helper'

module Sparrowhawk

  describe Configuration do
    let(:config) { Configuration.new }

    before do
      FileUtils.rm_rf current_dir
      create_file "Gemfile", ""
      create_file "Gemfile.lock", ""
    end
  
    it "includes the application's 'public' directory" do
      in_current_dir do
        config.should_receive(:public_dir_entries).and_return ['index.html', 'PUBLIC']
        config.war
      end
    end
    
    it "includes the default (rails) web.xml" do
      in_current_dir do
        config.war.entries.any? { |entry| entry.class.name == 'Sparrowhawk::WebXmlEntry' }.should be_true
      end
    end

    it "includes the manifest entry" do
      in_current_dir do
        config.should_receive(:manifest_entry)
        config.war
      end
    end

    it "includes application file entries" do
      in_current_dir do
        config.should_receive(:application_file_entries).and_return([])
        config.war
      end
    end
    
    it "includes the jruby-core jar" do
      in_current_dir do
        config.should_receive(:jruby_core_jar_entry)
        config.war
      end
    end

    it "includes the jruby-std jar" do
      in_current_dir do
        config.should_receive(:jruby_std_jar_entry)
        config.war
      end
    end
    
    it "includes the jruby-rack jar" do
      in_current_dir do
        config.should_receive(:jruby_rack_jar_entry)
        config.war
      end
    end

    it "includes other files, if they are specified" do
      in_current_dir do
        config.other_files = ["Gemfile", "Gemfile.lock"]
        config.should_receive(:file_entry).twice
        config.war
      end
    end
    
    it "doesn't include arbitrary files unless specified as other files" do
      in_current_dir do
        config.should_not_receive(:file_entry)
        config.war
      end
    end

    it "includes gem entries" do
      in_current_dir do
        config.should_receive(:gem_entries).and_return([])
        config.war
      end
    end

    context "for Rack applications" do
      it "includes the rack web.xml" do
        config.stub!(:rack_app?).and_return true
        config.war.entries.any? { |entry| entry.is_a? RackWebXmlEntry }.should be_true
      end

      it "is detected by default by looking for config.ru" do
        create_file "config.ru", "pfffft"
        in_current_dir do
          config.should be_a_rack_app
        end
      end

      it "can use any file a the rack configuration" do
        create_file "rack_me_up.rb", "pffft"
        in_current_dir do
          config.rack_config = File.expand_path("rack_me_up.rb")
          config.should be_a_rack_app
        end
      end
    end
  end
end
