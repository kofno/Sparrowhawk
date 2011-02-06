require 'spec_helper'

module Sparrowhawk

  describe LockfileEntry do
    let(:entry) { LockfileEntry.new }

    before do
      FileUtils.rm_rf current_dir
      write_file 'Gemfile.lock', 'This is the lockfile'
    end

    it "puts the lockfile in WEB-INF/" do
      in_current_dir { entry.name.should == 'WEB-INF/Gemfile.lock' }
    end

    it "reads its content from the lockfile at the app root" do
      in_current_dir { entry.content.should == 'This is the lockfile' }
    end

  end

end
