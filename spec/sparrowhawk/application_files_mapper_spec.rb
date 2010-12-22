require 'spec_helper'

module Sparrowhawk

  describe ApplicationFilesMapper do
    let(:mapper) { ApplicationFilesMapper.new }

    before do
      FileUtils.rm_rf current_dir
      create_file 'app/models/foo.rb', %Q{class Foo < ActiveRecord::Base;end}
      create_file 'config/database.yml', <<-DB_YAML
        development:
          adapter: sqlite3
          database: db/development.sqlite3
          pool: 5
          timeout: 5000
      DB_YAML
      create_file 'lib/bar.rb', %Q{class Bar;end}
    end

    it "maps app dir files the WEB-INF in the war" do
      in_current_dir { mapper.map(&:name).should include('WEB-INF/app/models/foo.rb') }
    end

    it "maps config dir files the WEB-INF in the war" do
      in_current_dir { mapper.map(&:name).should include('WEB-INF/config/database.yml') }
    end

    it "maps lib dir files the WEB-INF in the war" do
      in_current_dir { mapper.map(&:name).should include('WEB-INF/lib/bar.rb') }
    end

    it "should not include directories" do
      in_current_dir { mapper.map(&:name).should_not include('WEB-INF/app/models') }
    end

  end
end
