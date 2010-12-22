require 'spec_helper'

module Sparrowhawk

  describe ManifestEntry do
    let(:entry) { ManifestEntry.new }

    it "returns the entry name 'META-INF/MANIFEST.MF'" do
      entry.name.should == 'META-INF/MANIFEST.MF'
    end

    it "returns content w/ the manifest version" do
      entry.content.should =~ /^Manifest-Version: 1\.0$/
    end

    it "returns content w/ the application name and version" do
      entry.content.should =~ /^Created-By: 1\.0\.0\.pre \(Sparrowhawk\)$/
    end
  end

end
