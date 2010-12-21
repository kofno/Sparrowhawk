require 'spec_helper'

module Sparrowhawk

  describe PublicDirMapper do
    let(:mapper) { PublicDirMapper.new }

    before do
      FileUtils.rm_rf current_dir

      create_file "public/index.html", <<-HTML
        <html>
        <head><title>Welcome!</title></head>
        <body><h1>Welcome</h1></body>
        </html>
      HTML

      create_file "public/javascripts/application.js", <<-JS
        $(function() { doSomeStuff(); });
      JS
    end

    it "maps public/index.html to entry index.html" do
      in_current_dir { mapper.map(&:name).should include('index.html') }
    end

    it "maps public/javascripts/application.js to entry javascripts/application.js" do
      in_current_dir { mapper.map(&:name).should include('javascripts/application.js') }
    end

  end
end
