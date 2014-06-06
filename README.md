# MediaRSSParser

[![Build Status](https://travis-ci.org/JRG-Developer/MediaRSSParser.svg?branch=master)](https://travis-ci.org/JRG-Developer/MediaRSSParser)

`MediaRSSParser` is an easy-to-use parser for Media RSS, built on <a href="https://github.com/AFNetworking/AFNetworking/">AFNetworking</a>.

`MediaRSSParser` was inspired by and initially based on  <a href="https://github.com/tibo/BlockRSSParser">BlockRSSParser</a>. 

If you're switching from `BlockRSSParser` to `MediaRSSParser`, it should be pretty simple to do as the public method signatures are similar.

## Installation with CocoaPods

The easiest way to add `MediaRSSParser` to your project is using <a href="http://cocoapods.org">CocoaPods</a>. Add the following to your `Podfile` to include CocoaPods in your workspace:

`pod 'MediaRSSParser', '~> 1.0'`

Then simply run `pod install` as you normally do.

## Manual Installation

Alternatively, you can manually include `MediaRSSParser` in your project by doing the following:

1) Clone this repo locally onto your computer or press `Download ZIP` to simply download the latest `master` commit.

2) Drag the `MediaRSSParser` folder into your app project, making sure `Copy items into destination group's folder (if needed)` is checked.
	
3) Add <a href="https://github.com/AFNetworking/AFNetworking/">AFNetworking</a> to your project (it's a dependency of this library).

## How to Use

`MediaRSSParser` is designed to make working with Media RSS feeds quick and easy.

1) Add `#import "MediaRSSParser.h"` wherever you need to do RSS parsing, or `#import "MediaRSSModels.h"` wherever you just need to use the models.

2) Use the `RSSParser` class for parsing RSS feeds from a URL string. 

In example:

    RSSParser *parser = [[RSSParser alloc] init];
    self.parser = parser;
  
    __weak typeof(self) weakSelf = self;

    NSString *feedURLString = @"...";
    NSDictionary *parameters = @{@"...": @"..."};
  
    [self.parser parseRSSFeed:feedURLString
                    parameters:parameters
                       success:^(RSSChannel *channel) {
                            weakSelf.feedItems = channel.items;
                            [weakSelf.tableView reloadData];
                        } 
                        failure:^(NSError *error) {
                            NSLog(@"An error occurred: %@", error);
                        }];

3) The models you'll use most often are `RSSChannel`, which represents an RSS `channel` element, and `RSSItem`, which represents an RSS `item` element. 

See the header files for `RSSChannel` or `RSSItem` for documentation on these models.

(You can also clone this repo and check out the project's unit tests for examples for use examples.)

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

*Note:* if you're doing something very special for your project and need to create your own RSS namespace addition, this isn't likely to make it into the main repo.

Instead, you would be better off forking this repo, making your changes in your own branch, and periodically `pulling` changes from the main repo.

## Project Objectives

`MediaRSSParser` has specific goals in mind:

### Main Objective
1) To make it as easy as possible to work with RSS feeds and for third-party developers to use this repository.

This means, making it easy for third-party developers to quickly answer questions like these:

- "Where can I find specifications for the current version of RSS and/or Media RSS?" 

 -- See the main files (`MediaRSSParser.h` or `MediaRSSModels.h`), which have links to the documentation, but here they are just in case too: <a href="http://cyber.law.harvard.edu/rss/rss.html">RSS 2.0</a> and <a href="http://www.rssboard.org/media-rss">Media RSS 1.5.1</a>.

- "What is this property on this model for?" 

 -- See the header file of the model in question, which includes in-line documentation for each property.

- "How does the parser work, and how do I know it will continue to work in future versions?" 

 -- See the extensive reads-like-sentences unit tests for both use examples and in-code documentation on how things are suppose to work.

### Secondary Objectives
1) Document everything (100% documentation for all header files). 
This goes right along with "making it as easy as possible to use".

2) Unit test everything (100% unit testing of all code lines). 
This helps ensure the code works and will continue to work in the future.

## MediaRSSParser vs BlockRSSParser

`MediaRSSParser` was initially built on top of `BlockRSSParser`, but it has several design differences and goals:

The main difference is `MediaRSSParser` supports Media RSS (see http://www.rssboard.org/media-rss), and `BlockRSSParser` currently (as of 5/13/14) lacks support for this.

`MediaRSSParser` also explicitly provides model objects corresponding to complex RSS elements. In particular, `RSSChannel` correspond to the `channel` element, `RSSItem` corresponds to an `item` element, `RSSMediaContent` corresponds to a `media:content` element, etc.

`BlockRSSParser` instead uses `NSDictionary` objects to represent certain complex elements or omits such altogether. There also isn't a great plan in place for how `BlockRSSParser` might easily support additional elements or namespaces (such as Media RSS) in the future.

The main reasons `MediaRSSParser` uses native objects instead of dictionaries are: (i) it's usually easier for developers to work with native objects instead of object/key dictionary pairs, and (ii) it provides a clear path for supporting additional complex elements as needed in the future- simply by adding appropriate model objects that represent them.

## Git History of this Repository

`MediaRSSParser` is based on `BlockRSSParser` and diverges around version `2.1`. Thereby, the first version of `MediaRSSParser` is actually a divergent `3.0` version of `BlockRSSParser`. For this reason, the git history of `BlockRSSParser` is also included in the `MediaRSSParser` repository.

In an effort to avoid confusion, however, `MediaRSSParser` starts its own versioning over at `1.0` (as it's now a completely separate project from `BlockRSSParser`).

## Contributing

Patches and commonly-used tag additions are welcome!

To contribute:

1) Fork this repo.

2) Make your changes.

3) Write unit tests for your changes (as needed).

If you've never written unit tests before, that's okay! 

You can learn by checking out Jon Reid's (<a href="https://twitter.com/qcoding">@qcoding</a>) excellent <a href="http://qualitycoding.org">website</a>, including a <a href="http://qualitycoding.org/unit-testing/">section just about unit testing</a>.

4) Write documentation comments for your property and/or public method additions. 

If you're proposing new tags be added (e.g. support for another namespace), you *must* include a link to the online documentation.

This project is part of the CocoaPods specs repo, which includes appledoc-parsed documentation hosted for each pod on <a href="http://cocoadocs.org">CocoaDocs</a>. 

If you're not familar with appledoc, check out Mattt Thompson's (<a href="https://twitter.com/mattt">@matt</a>) introductory <a href="http://nshipster.com/documentation/">post about it</a>.

5) Submit a pull request. 

Make sure to include your rationale for why this change is needed (especially for new tag additions).

6) Last but not least, sit back and enjoy your awesomeness in helping make your fellow developers' lives a bit easier!

Thank You !!!!

## License

Like `BlockRSSParser` and `AFNetworking`, this project is available under the MIT license (see the `LICENSE` file for more details).