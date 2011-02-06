require 'spec_helper'

module Sparrowhawk

  describe GemfileEntry do
    let(:entry) { GemfileEntry.new }

    before do
      FileUtils.rm_rf current_dir
      write_file 'Gemfile', 'This is the gemfile'
    end

    it "puts the gemfile in WEB-INF/" do
      in_current_dir { entry.name.should == 'WEB-INF/Gemfile' }
    end

    it "uses the Gemfile on disk for content" do
      in_current_dir { entry.content.should == 'This is the gemfile' }
    end
  end

end
