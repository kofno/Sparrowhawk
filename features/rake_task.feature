Feature: Rake task

  Sparrowhawk can be run from rake, using the provided rake task

  @announce
  Scenario: with default options produceds a war file
    Given a file named "Rakefile" with:
       """
       $LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
       require 'sparrowhawk/rake_task'

       Sparrowhawk::RakeTask.new

       task :default => :war
       """
      And a file named "public/index.html" with:
       """
       <html><head><title>Welcome!</title></head><bobdy><h1>Welcome!</h1></body></html>
       """
     When I run "rake"
     Then the exit status should be 0
      And a file named "aruba.war" should exist
     When I run "unzip aruba.war"
     Then the output should contain "inflating: index.html"
