require 'spec_helper'

module Sparrowhawk

  describe FileEntry do
    let(:entry) { FileEntry.new('sample.txt', 'public/sample.txt') }

    before do
      FileUtils.rm_rf current_dir

      create_file "public/sample.txt", "Have a nice day!"
    end

    it "gets its content from the specified source file" do
      in_current_dir do
        entry.content.should == "Have a nice day!"
      end
    end

  end
end
