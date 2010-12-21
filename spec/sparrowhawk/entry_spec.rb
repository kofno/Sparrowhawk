require 'spec_helper'

module Sparrowhawk
  describe Entry do
    let(:entry) { Entry.new 'a/name', 'and some content' }

    it "has a name (like a file path)" do
      entry.name.should == 'a/name'
    end

    it "has content" do
      entry.content.should == 'and some content'
    end

  end
end
