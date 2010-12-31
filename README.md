## Sparrowhawk: The Warbler Killer

'The Warbler Killer' is kind of tongue-in-cheek. Sparrowhawk is for teams that would like to distribute their application as a WAR file, but prefer that their distribution tool chain remain purely MRI. That's not to say that Sparrowhawk won't run on JRuby, just that the goal was to produce a tool that would run on any ruby.

Documentation is a little sparse at the moement. The test rake_task.feature demonstrates using the rake task. You can review the source and report issues at Github:
* [Source](https://github.com/kofno/Sparrowhawk)
* [Bug Tracker](https://github.com/kofno/Sparrowhawk/issues)

You can also follow our progress on [Pivotal Tracker](https://www.pivotaltracker.com/projects/164959#)

## Why Sparrowhawk?

Why would you pick Sparrowhawk over another tool, like, ohhhhh I don't know... Warbler?

I can think of two reasons.

First, we run on any ruby (or, we will, by 1.0.0)

The second reason depends on preference. Warbler is a command line tool based on rake. To use warbler, you need to load up all of rake. There are times when this can have negative ramifications.

>TODO: Give examples of negative ramifications

Sparrowhawk, on the other hand, is a library for packaging Rack applications as war files. It happens that sparrowhawk ships with a rake task, but rake isn't required to use Sparrowhawk.

## Notes and Warnings

Sparrowhawk was built to package TriSano.

Sparrowhawk only does rails applications so far. Full Rack support is forth coming, but wasn't our first priority.

I've only tested Sparrowhawk on Rails 2.3.x applications w/ bundler integration (a niche group, to be certain). It does, however, work beautifully on one such application (TriSano).
