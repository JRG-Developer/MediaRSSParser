# MediaRSSParser

This is a simple Media RSS Parser, built on <a href="https://github.com/AFNetworking/AFNetworking/">AFNetworking</a>.

`MediaRSSParser` was initially inspired by and based on <a href="https://github.com/tibo/BlockRSSParser">BlockRSSParser</a>.

While some similarities still exist, this project has taken a different path from `BlockRSSParser` (for the reasons discussed below). However, it should be simple to upgrade a project from `BlockRSSParser` as the public method signatures are similar.

## Getting Started

`MediaRSSParser` will soon be added to CocoaPods.

Until then, follow these instructions to add it to your project manually:

1. Clone this repo locally onto your computer or press `Download ZIP` to simply download the latest `master` commit.

2. Drag the `MediaRSSParser` folder into your app project, making sure `Copy items into destination group's folder (if needed)` is checked.
	
3. Add <a href="https://github.com/AFNetworking/AFNetworking/">AFNetworking</a> to your project (either manually or via CocoaPods).

4. Add `#import "MediaRSSParser.h"` wherever you need to do RSS parsing, or `#import "MediaRSSModels.h"` wherever you just need to use the models.

5. See the class methods in `RSSParser.h` or the unit tests in `RSSParserTests.m` for how to use the RSS parser and models (full tutorial coming soon).

# Versioning and Git History

`MediaRSSParser` is based on `BlockRSSParser` and diverges around version `2.1`. Thereby, the first version of `MediaRSSParser` is actually a divergent `3.0` version of `BlockRSSParser`. For this reason, the `git` history of `BlockRSSParser` is included in the `MediaRSSParser` repository.

In an effort to avoid confusion, `MediaRSSParser` starts its versioning over at `1.0` (as it's now a completely separate project from `BlockRSSParser`).

## The RSS Protocol

Let's be honest: RSS is one of the worst protocols in the world. Unfortunately, it's also one of the most commonly used.

Why is this the case? I imagine it's because it's relatively easy for server side developers/admins to setup; it's been around forever; and it "feels" familiar (because at first glance it seems simple).

There are many problems with RSS, but there are at least two main issues with it:

1) While there *is* an RSS specification, there are many different interpretations and/or variations on it.

Consequently, the same `element` may be used slightly different across content providers or sometimes named differently (e.g. `item` vs. `entry`). Some providers may say they conform to the specification, but their feed may be missing required elements or may incorrectly name elements (so it really doesn't conform).

To narrow the scope of this project, `RSS 2.0` will be considered the base specification, as defined at this <a href="http://cyber.law.harvard.edu/rss/rss.html">RSS 2.0 Specification mirror</a>.

2) The RSS specification also allows for the addition of new elements via a namespace.

Hence, Media RSS is actually just a namespace addition to RSS 2.0.

Again to narrow the project scope, `Media RSS` will be considered to mean the namespace specification defined at this <a href="http://www.rssboard.org/media-rss">Media RSS mirror</a>.

This project aims to mitigate these issues by doing the following:

1) Allowing for *matcher methods* (see `RSSParser.m` private methods) that allow different element names to match the same model object/property (e.g. `item` and `entry` both map to an `RSSItem` object).

2) Allowing for the addition of other RSS namespace elements, as long as they are (i) commonly used (per popular request, if you will, by other developers using this project), and (ii) have an online webpage describing the namespace specification.

If you're doing something very special for your project and need to create your own RSS namespace addition, this isn't likely to make it into the main repo.

Instead, you would be better off forking this repo, making your changes solely in your own branch, and periodically `pulling` changes from the main repo.

## MediaRSSParser vs BlockRSSParser

`MediaRSSParser` was initially built on top of `BlockRSSParser`, but it has several design differences and goals:

The main difference is `MediaRSSParser` supports Media RSS (see http://www.rssboard.org/media-rss), and `BlockRSSParser` currently (as of 5/13/14) lacks support for this.

`MediaRSSParser` also explicitly provides model objects corresponding to complex RSS elements. In particular, `RSSChannel` correspond to the `channel` element, `RSSItem` corresponds to an `item` element, `RSSMediaContent` corresponds to a `media:content` element, etc.

`BlockRSSParser` instead uses `NSDictionary` objects to represent certain complex elements or omits such altogether. There also isn't a great plan in place for how `BlockRSSParser` might easily support additional elements or namespaces (such as Media RSS) in the future.

The main reasons `MediaRSSParser` uses native objects instead of dictionaries are: (i) it's usually easier for developers to work with native objects instead of object/key dictionary pairs, and (ii) it provides a clear path for supporting additional complex elements as needed in the future- simply by adding appropriate model objects that represent them.

`MediaRSSParser` has specific goals in mind:

1) Make it as easy for third-party developers to use it. This means, making it as easy as possible for third-party developers to quickly answer questions like

- "What is this property for?" (See the header files of the models, which are clearly commented including notes from the documentation)

- "Where can I find specifications for the current version of RSS and/or Media RSS?" (See the main header files `MediaRSSParser.h` or `MediaRSSModels.h` or many of the model headers too... but here they are just in case too: <a href="http://cyber.law.harvard.edu/rss/rss.html">RSS 2.0</a> and <a href="http://www.rssboard.org/media-rss">Media RSS 1.5.1</a>

- "How does the parser work and/or how do I know it will continue to work in future versions?" (See the extensive reads-like-sentences unit tests for both use examples and in-code documentation on how things are suppose to work.)

2) Document everything - this goes right along with making it easy for other developers to use it and keeping the project maintainable in the future.

3) Unit test everything - again, this makes it easier for other developers to use (as it provides use examples) and helps with maintability... plus, you know, it doesn't feel right if those tests aren't there, right? ;]

## Contributing

Patches and commonly-used tag additions are welcome!

To contribute:

1) Fork this repo.

2) Make your changes.

3) Write unit tests for your changes (as needed). If possible, a TDD approach is best!

If you've never written unit tests before, that's okay! You can learn by checking out Jon Reid's (<a href="https://twitter.com/qcoding">@qcoding</a>) excellent <http://qualitycoding.org/>website<a>, including a <a href="http://qualitycoding.org/unit-testing/">section just about unit testing</a>.

4) Write documentation comments for your changes (as needed). If you're proposing new tags be added, you *must* include a link to the namespace documentation.

This project is (or will be soon) part of CocoaPods specs repo, which includes appledoc-parsed documentation hosted for each pod on <a href="http://cocoadocs.org">CocoaDocs</a>. If you're not familar with appledoc, check out Mattt Thompson's (<a href="https://twitter.com/mattt">@matt</a>) introductory <a href="">post about it</a>

5) Submit a pull request. 

Make sure to include your rationale for why this change is needed (especially for new tag additions).

6) Last but not least, sit back and enjoy your awesomeness in helping make your fellow developers' lives a bit easier!

Thank You!!!!</li>

## License

Like `BlockRSSParser` and `AFNetworking`, this project is available under the MIT license (see the `LICENSE` file for more details).
