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
      create_file 'vendor/plugins/some_plugin/init.rb', "require 'me'"
      create_file 'vendor/cache/pg-0.0.9.gem', "Pretend I'm a gem"
      create_file 'other_plugins/a_plugin/init.rb', 'A symlinked plugin'
      in_current_dir do
        FileUtils.ln_s File.expand_path('other_plugins/a_plugin'), File.expand_path('vendor/plugins/a_plugin')
      end
      create_file "root_file", "Don't grab me"
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

    it "should include vendor directories (like plugins)" do
      in_current_dir { mapper.map(&:name).should include('WEB-INF/vendor/plugins/some_plugin/init.rb') }
    end

    it "should not include any files from vendor/cache" do
      in_current_dir { mapper.map(&:name).should_not include('WEB-INF/vendor/cache/pg-0.0.9.gem') }
    end

    it "should negotiate symlinks as though they were directories" do
      in_current_dir { mapper.map(&:name).should include('WEB-INF/vendor/plugins/a_plugin/init.rb') }
    end

    it "should not include files from the application root directory" do
      in_current_dir { mapper.map(&:name).should_not include('WEB-INF/root_file') }
    end

    context "with a custom directory list excluding plugins" do
      let(:mapper) { ApplicationFilesMapper.new *%w(app config lib) }

      it "should ignore files in the vendor directory" do
        in_current_dir { mapper.map(&:name).should_not include('WEB-INF/vendor/plugins/some_plugin/init.rb') }
      end
    end

  end
end
