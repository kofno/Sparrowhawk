require 'spec_helper'

module Sparrowhawk

  describe War do

    before do
      FileUtils.rm_rf current_dir
    end

    context "#build" do
      let(:war) { War.new }

      it "creates a war file  named for the current current directory" do
        in_current_dir { war.build.should exist }
      end

      it "inserts entries into the new war file" do
        war.entries << Entry.new('test.txt', 'Some text')
        in_current_dir { war.build.should have_entry('test.txt') }
      end

    end

  end

end
