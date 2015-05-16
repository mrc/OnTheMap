OnTheMap
========



WHAT IS THE CODE DOING?
-----------------------

The networking code is based on the ideas presented in the talk
[Networking with Monads](http://2014.funswiftconf.com/speakers/john.html)
([watch](https://www.youtube.com/watch?v=LqwrUmuodyY)).

The idea is to structure the code around the "happy path"; by
abstracting side effects (such as errors or latency), the happy
path can be built by gluing functions together.

By composing side effects in this way, we avoid a deep nest of error
handling code and completion blocks, that gets deeper with every stage
of the process.

Errors are handled by the `Result` type. A good introduction to this
concept is the article
[Railway oriented programming - a recipe for a functional app](http://fsharpforfunandprofit.com/posts/recipe-part2/).

![The main track captures the happy path](http://fsharpforfunandprofit.com/assets/img/Recipe_Function_ErrorTrack.png)

The "main" track is built from a bunch of pieces that each take the
successful result of the previous piece, do some work (such as parsing
a JSON response), and either pass their successful result into the
next piece, or short-circuit their errors back to the original caller.

Each piece of track is a function with a signature designed to be
composed with other pieces of track. It can be a hand crafted function
(combined with `bind`), or built by "lifting" a function with a
simpler signature (with `map`.)

The flow of network requests (fetch this, then fetch that) is handled
by the `Deferred` type, which allows asynchronous functions to be
composed into a larger asynchronous work flow. By treating asynchrony
as part of the function signature, the "pieces of track" can be
connected in a straight line - compare this to a deep nest of
completion blocks.

Although the general pattern is the same (abstracting side effects to
create functions that can be composed), the "asynchronous" pieces of
track and the "error switching" pieces of track have different
"connectors" (signatures). One can be transformed into the other using
functions such as `Result.toDeferred` (in
[ResultT.swift](OnTheMap/Utilities/ResultT.swift)).

BUILDING
--------
This project uses some 3rd party projects to help manage asynchrony:

- [Deferred](https://github.com/bignerdranch/Deferred) as a composable
alternative to completion blocks.

- [Result](https://github.com/bignerdranch/Result) for combining
errors with results in a
[Railway oriented programming](http://fsharpforfunandprofit.com/rop/)
style, to simplify result processing.

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
