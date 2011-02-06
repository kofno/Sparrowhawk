## Sparrowhawk: The Warbler Killer

'The Warbler Killer' is kind of tongue-in-cheek. Sparrowhawk is for teams that would like to distribute their application as a WAR file, but prefer that their distribution tool chain remain purely MRI. That's not to say that Sparrowhawk won't run on JRuby, just that the goal was to produce a tool that would run on any ruby.

Documentation is a little sparse at the moment. The test rake_task.feature demonstrates using the rake task. You can review the source and report issues at Github:

* [Source](https://github.com/kofno/Sparrowhawk)
* [Bug Tracker](https://github.com/kofno/Sparrowhawk/issues)
* [RDoc](http://rubydoc.info/github/kofno/Sparrowhawk/master/frames)

You can also follow our progress on [Pivotal Tracker](https://www.pivotaltracker.com/projects/164959#)

## Install

Sparrowhawk is distributed as a gem:

    $ gem install sparrowhawk

Or add Sparrowhawk to your Gemfile:

    # Gemfile
    gem "sparrowhawk"

    #CLI
    $ bundle install --local

## Usage

### Rake Task
Sparrowhawk ships with a rake task.

    require 'sparrowhawk/rake_task'

    Sparrowhawk::RakeTask.new

This will create a task named 'war' in your project. If you don't like that name, you can change it:

    Sparrowhawk::RakeTask.new :package

Now you'll have a task named 'package' instead.

Sparrowhawk will try to do the right thing, but it sometimes will need a little coaxing.

    Sparrowhawk::RakeTask.new do |t|
      t.other_files = FileList['README', 'LICENSE', 'CHANGELOG']
      t.runtimes = 1..5
    end

This configuration adds three additional files to the war, and sets the minimum number of runtimes to one, and the maiximum to five.

There are only a few configuration options. They are documented [here](http://rubydoc.info/github/kofno/Sparrowhawk/master/Sparrowhawk/Configuration)

### Programmatic

The rake example above could have been written this way:

    require 'sparrowhawk'
    
    task :war do
      Sparrowhawk::Configuration.new do |c|
        c.other_files = FileList['README', 'LICENSE', 'CHANGELOG']
        c.runtimes = 1..5
      end.war.build
    end

This produces the exact same outcome. So why bother? The nice thing about the Configuration class is that it is fairly extensible. If, for example, you were using Sparrowhawk, but didn't want to use bundler to manage you gem files. In that case, you might extend the Configuration class and write youe own implementation of the #gem_entities method.

    class MyWarConfig < Sparrowhawk::Configuration
     
      def gem_entries
        # my impl
        ...
      end
    end
    
    task :war do
      MyWarConfig.new.war.build
    end

## Why Sparrowhawk?

So, why did I build Sparrowhawk?

1. I needed to a reliable way to build a war file on MRI. This means:
    - Handling symlinks correctly on MRI
    - Packaging for the JRuby platform, even from MRI
2. I wanted a simple, programatic way to build war files.
    - No extra config files
    - Minimal configuration
3. Whenever I would update Warbler, something would break

That being said, Warbler is a fine tool, and if your needa aren't similar to mine, there's probably not a good reason to switch.

## Notes and Warnings

So far, I've packaged and deployed a large rails (2.3.x) app and a small sinatra app. Rack support is very new, but I would expect to be able to package most rails or rack based applications, provided they are compatible on JRuby. However, the current sample size is small.

Sparrowhawk requires bundler!

For Sparrowhawk to work from MRI, you must package your bundle, and you must bundle install --local from JRuby at least once. This is so bundler can find the java versions of your gems.

Ruby Implementations (implementations that I have run Sparrowhawk with):
- REE
- JRuby 1.5.6

## Word!

If you're using Sparrowhawk, drop me a line. I'd love to hear about it!
