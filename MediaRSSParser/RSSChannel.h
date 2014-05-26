//
//  RSSChannel.h
//  MediaRSSParser
//
//  Created by Joshua Greene on 5/25/14.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>

/**
 *  `RSSChannel` corresponds to a single RSS `channel` element within an RSS feed.
 *
 *  All of the properties on `RSSChannel` are from the RSS 2.0 specification. Some properties are required (meaning they *must* appear in a valid RSS feed) and some are optional (meaning they *may* appear in a valid RSS feed).
 */
@interface RSSChannel : NSObject <NSCoding>

#pragma mark - RSS 2.0 - Required Elements
///---------------------
/// @name RSS 2.0 - Required Elements
///---------------------

/**
 *  This property corresponds to the `title` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "name of the channel."
 */
@property (nonatomic, copy) NSString *title;

/**
 *  This property corresponds to the `link` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "URL to the HTML website corresponding to the channel."
 */
@property (nonatomic, copy) NSURL *link;

/**
 *  This property corresponds to the `description` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is "a phrase or sentence describing the channel."
 */
@property (nonatomic, copy) NSString *channelDescription;

#pragma mark - RSS 2.0 - Optional Elements
///---------------------
/// @name RSS 2.0 - Optional Elements
///---------------------

/**
 *  This property corresponds to the `language` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "language the channel is written in."
 */
@property (nonatomic, copy) NSString *language;

/**
 *  This property corresponds to the `copyright` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "copyright notice for content in the channel."
 */
@property (nonatomic, copy) NSString *copyright;

/**
 *  This property corresponds to the `managingEditor` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "email address for the person responsible for editorial content."
 */
@property (nonatomic, copy) NSString *managingEditorEmail;

/**
 *  This property corresponds to the `webMaster` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "email address for the person responsible for technical issues relating to the channel."
 */
@property (nonatomic, copy) NSString *webMasterEmail;

/**
 *  This property corresponds to the `pubDate` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "publication date for the content in the channel."
 */
@property (nonatomic, copy) NSDate *pubDate;

/**
 *  This property corresponds to the `lastBuildDate` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is the "last time the content of the channel changed."
 *
 *  The date format is expected to be `EEE, dd MMM yyyy HH:mm:ss Z`.
 */
@property (nonatomic, copy) NSDate *lastBuildDate;

/**
 *  This property corresponds to the `generator` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is "a string indicating the program used to generate the channel."
 *
 *  The date format is expected to be `EEE, dd MMM yyyy HH:mm:ss Z`.
 */
@property (nonatomic, copy) NSString *generator;

/**
 *  This property corresponds to the `docs` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is "a URL that points to the documentation for the format used in the RSS file."
 */
@property (nonatomic, copy) NSURL *docsURL;

/**
 *  This property is short for "time to live" and corresponds to the `ttl` element within a `channel` element.
 *  
 *  Per the RSS 2.0 specification, it is "a number of minutes that indicates how long a channel can be cached before refreshing from the source."
 */
@property (nonatomic, assign) NSInteger ttl;

/**
 *  This property contains an array of `RSSItem` objects corresponding to the `item` elements within a `channel` element.
 */
@property (nonatomic, copy) NSArray *items;

@end
