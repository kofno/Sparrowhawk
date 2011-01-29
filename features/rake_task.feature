Feature: Rake task

  Sparrowhawk can be run from rake, using the provided rake task

  Background:
    Given a file named "public/index.html" with:
       """
       <html><head><title>Welcome!</title></head><bobdy><h1>Welcome!</h1></body></html>
       """
      And a file named "Gemfile.lock" with:
       """
       GEM
         remote: http://rubygems.org/
         specs:
           nokogiri (1.4.3.1)
           nokogiri (1.4.3.1-java)
             weakling (>= 0.0.3)

       PLATFORMS
         java
         ruby

       DEPENDENCIES
         nokogiri
       """
      And a file named "Gemfile" with:
       """
       source :gemcutter
       gem 'nokogiri'
       """

  Scenario: Default options
    Given a file named "Rakefile" with:
       """
       $LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
       require 'sparrowhawk/rake_task'

       Sparrowhawk::RakeTask.new

       task :default => :war
       """
     When I run "rake"
     Then the exit status should be 0
      And a file named "aruba.war" should exist
     When I run "unzip -Z aruba.war"
     Then the output should contain "index.html"
      And the output should contain "WEB-INF/web.xml"
      And the output should contain "META-INF/MANIFEST.MF"
      And the output should contain "WEB-INF/lib/jruby-rack-1.0.4.jar"

  Scenario: Renaming the task
    Given a file named "Rakefile" with:
       """
       $LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
       require 'sparrowhawk/rake_task'

       Sparrowhawk::RakeTask.new :package

       task :default => :package
       """
     When I run "rake"
     Then the exit status should be 0
      And a file named "aruba.war" should exist

  Scenario: Configuring the task
    Given a file named "Rakefile" with:
       """
       $LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
       require 'sparrowhawk/rake_task'

       Sparrowhawk::RakeTask.new do |task|
         task.war_file = 'example.war'
         task.application_dirs = %w(app config lib vendor db)
         task.other_files = FileList['Rakefile']
       end

       task :default => :war
       """
     When I run "rake"
     Then the exit status should be 0
      And a file named "example.war" should exist
     When I run "unzip -Z example.war"
     Then the output should contain "WEB-INF/Rakefile"

  Scenario: Run the task from a subdirectory
    Given a file named "Rakefile" with:
       """
       $LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
       require 'sparrowhawk/rake_task'

       Sparrowhawk::RakeTask.new

       task :default => :war
       """
     When I cd to "public"
      And I run "rake"
     Then the exit status should be 0
      And a file named "../aruba.war" should exist
     When I run "unzip -Z ../aruba.war"
     Then the output should contain "index.html"
      And the output should contain "WEB-INF/web.xml"
      And the output should contain "META-INF/MANIFEST.MF"
      And the output should contain "WEB-INF/lib/jruby-rack-1.0.4.jar"

  Scenario: A generic rack application
    Given a file named "config.ru" with:
       """
       require "rubygems"
       require "bundler"
       Bundle.require

       run 'MyApplication'
       """
      And a file named "Rakefile" with:
       """
       $LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
       require 'sparrowhawk/rake_task'

       Sparrowhawk::RakeTask.new

       task :default => :war
       """
     When I run "rake"
     Then the exit status should be 0
      And a file named "aruba.war" should exist
