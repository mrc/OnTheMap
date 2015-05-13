OnTheMap
========

BUILDING
--------
This project uses some 3rd party projects to help manage asynchrony:

- [Deferred](https://github.com/bignerdranch/Deferred) for handling
  completion blocks in a
  [Railway oriented programming](http://fsharpforfunandprofit.com/rop/)
  style.
- [Result](https://github.com/bignerdranch/Result) for combining
errors with results, to simplify result processing.

[Carthage](https://github.com/Carthage/Carthage/) is used to manage
these dependencies. To update dependencies, install Carthage ("brew
install carthage" then "carthage update".)

If [Homebrew](http://brew.sh/) is used to install Carthage, you will
probably have /usr/local/bin/carthage. Otherwise, you might make a
symlink there to wherever you have Carthage installed. This is used by
a build phase of the project.

CREDITS
-------
- Concept from Udacity course
  [iOS Networking with Swift](https://www.udacity.com/course/ios-networking-with-swift--ud421).

