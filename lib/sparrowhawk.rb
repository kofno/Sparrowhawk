require 'rubygems'
require 'bundler/setup'

module Sparrowhawk

  autoload :War             ,'sparrowhawk/war'

  autoload :Entry           ,'sparrowhawk/entry'
  autoload :FileEntry       ,'sparrowhawk/file_entry'
  autoload :WebXmlEntry     ,'sparrowhawk/web_xml_entry'

  autoload :PublicDirMapper ,'sparrowhawk/public_dir_mapper'

end
