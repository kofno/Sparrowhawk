require 'spec_helper'

module Sparrowhawk

  describe GemMapper do
    let(:gem) do
      spec = double(:spec,
                    :to_ruby => 'spec content',
                    :spec_name => 'example-1.0.gemspec',
                    :full_name => 'example-1.0')
      file_entries = [[{"path" => ".gitignore"}, "/tmp\n"]]
      double :gem_format, :spec => spec, :file_entries => file_entries
    end

    before do
      FileUtils.rm_rf current_dir
    end

    it "maps gem specifications to 'WEB-INF/gems/specifications'" do
      GemMapper.new([gem]).map do |entry|
        [entry.name, entry.content]
      end.should include(['WEB-INF/gems/specifications/example-1.0.gemspec', 'spec content'])
    end

    it "maps gem files to 'WEB-INF/gems/gems/<gem-name-version>'" do
      GemMapper.new([gem]).map do |entry|
        [entry.name, entry.content]
      end.should include(['WEB-INF/gems/gems/example-1.0/.gitignore', "/tmp\n"])
    end

  end

end
