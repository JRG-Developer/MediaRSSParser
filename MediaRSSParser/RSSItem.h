//
//  RSSItem.h
//  RSSParser
//
//  Modified by Joshua Greene on 4/2/14 (added support for Media RSS).
//  Created by Thibaut LE LEVIER on 2/3/12.
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
 *  `RSSItem` corresponds to a single RSS `item` or `entry` element within an RSS feed.
 */
@interface RSSItem : NSObject <NSCoding>

/**
 *  Corresponds to the `title` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *title;

/**
 *  Corresponds to the `description` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *itemDescription;

/**
 *  Corresponds to the `content` or `content:encoded` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *content;

/**
 *  Corresponds to the `link` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSURL *link;

/**
 *  Corresponds to the `comments` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSURL *commentsLink;

/**
 *  Corresponds to the `wfw:commentRss` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSURL *commentsFeed;

/**
 *  Corresponds to the `slash:comments` element within an RSS `item` or `entry` element.
 */

@property (nonatomic, copy) NSNumber *commentsCount;

/**
 *  Corresponds to the `pubDate` element within an RSS `item` or `entry` element. The date format is expected to be `EEE, dd MMM yyyy HH:mm:ss Z`.
 */
@property (nonatomic, copy) NSDate *pubDate;

/**
 *  Corresponds to the `dc:creator` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *author;

/**
 *  Corresponds to the `guid` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *guid;

/**
 *  Corresponds to the `media:title` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *mediaTitle;

/**
 *  Corresponds to the `media:description` element within an RSS RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *mediaDescription;

/**
 *  Corresponds to the `media:text` element within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSString *mediaText;

/**
 *  This is an array of `RSSMediaCredit` objects, corresponding to the `media:credit` elements within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSArray *mediaCredits;

/**
 *  This is an array of `RSSMediaItem` objects, corresponding to the `media:thumbnail` elements within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSArray *mediaThumbnails;

/**
 *  This is an array of `RSSMediaItem` objects, corresponding to the `media:content` elements within an RSS `item` or `entry` element.
 */
@property (nonatomic, copy) NSArray *mediaContents;

/**
 *  Calls `imagesFromHTML:` passing in its `itemDescription` property.
 *  @return An array of `NSString` objects containing links (strings starting within `http` or `https`) to all images from the `itemDescription` property.
 */
- (NSArray *)imagesFromItemDescription;

/**
 *  Calls `imagesFromHTML:` passing in its `content` property.
 *  @return An array of `NSString` objects containing links (strings starting within `http` or `https`) to all images from the `content` property.
 */
- (NSArray *)imagesFromContent;

/**
 *  Creates an array of `NSString` objects containing links (starting with either `http` or `https` only) to all images from the passed in `html` property. This method uses an `NSRegularExpression` to search for strings matching the format `(https?)\\S*(png|jpg|jpeg|gif)`.
 *
 *  @param html The string to search for images (http(s) links).
 *
 *  @return An array of `NSString` objects containing links (strings starting within `http` or `https`) to all images within the passed in `html` string.
 */
- (NSArray *)imagesFromHTML:(NSString *)html;

@end
