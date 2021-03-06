require 'bundler'

module Sparrowhawk
  VERSION = "0.9.6"

  autoload :War                        , 'sparrowhawk/war'
  autoload :Configuration              , 'sparrowhawk/configuration'

  autoload :Entry                      , 'sparrowhawk/entry'
  autoload :FileEntry                  , 'sparrowhawk/file_entry'
  autoload :WebXmlEntry                , 'sparrowhawk/web_xml_entry'
  autoload :RailsWebXmlEntry           , 'sparrowhawk/rails_web_xml_entry'
  autoload :RackWebXmlEntry            , 'sparrowhawk/rack_web_xml_entry'
  autoload :ManifestEntry              , 'sparrowhawk/manifest_entry'
  autoload :JarEntry                   , 'sparrowhawk/jar_entry'
  autoload :JRubyCoreJarEntry          , 'sparrowhawk/jruby_core_jar_entry'
  autoload :JRubyStdLibJarEntry        , 'sparrowhawk/jruby_stdlib_jar_entry'
  autoload :JRubyRackJarEntry          , 'sparrowhawk/jruby_rack_jar_entry'
  autoload :GemfileEntry               , 'sparrowhawk/gemfile_entry'
  autoload :LockfileEntry              , 'sparrowhawk/lockfile_entry'
  autoload :BundlerConfigurationEntry  , 'sparrowhawk/bundler_configuration_entry'

  autoload :FileEntryMapper            , 'sparrowhawk/file_entry_mapper'
  autoload :PublicDirMapper            , 'sparrowhawk/public_dir_mapper'
  autoload :ApplicationFilesMapper     , 'sparrowhawk/application_files_mapper'
  autoload :GemMapper                  , 'sparrowhawk/gem_mapper'
  autoload :BundlerArtifactMapper      , 'sparrowhawk/bundler_artifact_mapper'

  autoload :BundlerGemFinder           , 'sparrowhawk/bundler_gem_finder'
  autoload :BundlerDefinition          , 'sparrowhawk/bundler_definition'
  autoload :Index                      , 'sparrowhawk/index'

  autoload :RakeTask                   , 'sparrowhawk/rake_task'
end
