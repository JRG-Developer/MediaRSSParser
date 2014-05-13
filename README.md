# MediaRSSParser

This is a simple Media RSS Parser, built on <a href=“https://github.com/tibo/BlockRSSParser”>BlockRSSParser</a> and <a href="https://github.com/AFNetworking/AFNetworking/">AFNetworking</a>.

## Getting Started

MediaRSSParser will soon be added to CocoaPods.

Until then, follow these instructions to add it to your project manually:

1. Drag the `MediaRSSParser` folder into your project, making sure `copy into project` is checked`.
	
2. You also need to add <a href="https://github.com/AFNetworking/AFNetworking/">AFNetworking</a> to your project (either manually or via CocoaPods).

3. `#import “RSSMediaParser.h”` wherever you need it.

4. See the class methods `RSSParser.h` for how to use it.

## RSS Standards

RSS is one of the worst protocols in the world. Unfortunately, it’s also one of the most commonly used.

There are so many “standards” to describe an RSS feed, and there isn’t much consistency between them.

This parser is optimized to work with Wordpress (simple RSS) and Deviant Art (Media RSS) feeds. Some information, like `comments` or `media` tags, may not be present in all providers’ feeds.

## MediaRSSParser vs BlockRSSParser

`MediaRSSParser` is built on top of `BlockRSSParser`, but it has several differences:

The main difference is that support for `Media RSS` has been added to `MediaRSSParser`, where `BlockRSSParser` lacks this support (as of the current version on 5/13/14).

`MediaRSSParser` also explicitly provides model objects for `RSSMediaCredit` and `RSSMediaItem` (used for both `media:thumbnails` and `media:content` tag types), where `BlockRSSParser` uses an `NSDictionary` for `media credit` and doesn’t have a great plan in place for supporting `media:` tag types.

The main reason for using model objects instead of a dictionary is that it’s usually easier for developers to work with native objects, instead of having to work with objects and keys in a dictionary.

## Contributing

Patches and additions are welcome!

If you include support for a new tag type, please make sure that it’s common enough that others are likely to benefit from its inclusion in this project.

To contribute:

1) Fork this repo.

2) Make your changes.

3) Submit a pull request. Make sure to include your rationale for why this change is needed (especially for new tag support).

## License

Like BlockRSSParser and AFNetworking, this project is available under the MIT license (see the LICENSE file for more details).
