require 'spec_helper'

module Sparrowhawk

  describe War do
    let(:war) { War.new }

    before do
      FileUtils.rm_rf current_dir
    end

    it "creates a war file named for the current directory" do
      in_current_dir { war.build.should exist }
    end

    it "can rename war file when generating" do
      in_current_dir do
        War.new('example.war').build.should exist
      end
    end

    it "inserts entries into the new war file" do
      war.entries << Entry.new('test.txt', 'Some text')
      in_current_dir { war.build.should have_entry('test.txt') }
    end
  end

end
