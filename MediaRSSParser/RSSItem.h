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
 *  `RSSItem` corresponds to a single `item` or `entry` element within an RSS feed.
 *
 *  Many properties on `RSSItem` are from the RSS 2.0 specification, see http://cyber.law.harvard.edu/rss/rss.html for reference, and some are from the Media RSS 1.5.1 specification, see http://www.rssboard.org/media-rss for reference,  which is a namespace extension to the RSS 2.0 specification.
 *
 *  Per the RSS 2.0 specification, "an item may represent a "story" -- much like a story in a newspaper or magazine; if so its description is a synopsis of the story, and the link points to the full story. An item may also be complete in itself, if so, the description contains the text (entity-encoded HTML is allowed), and the link and title may be omitted. All elements of an item are optional, however at least one of title or description must be present."
 */
@interface RSSItem : NSObject <NSCoding>

#pragma mark - RSS 2.0
///---------------------
/// @name RSS 2.0
///---------------------

/**
 *  This property corresponds to the `title` element within an `item` element.
 *
 *  Per RSS 2.0 specification, it is the "title of the item."
 */
@property (nonatomic, copy) NSString *title;

/**
 *  This property corresponds to the `link` element within an `item` element.
 *
 *  Per RSS 2.0 specification, it is the "URL of the item," e.g. to the HTML web page for the item.
 */
@property (nonatomic, copy) NSURL *link;

/**
 *  This property corresponds to the `description` element within an `item`. 
 *  
 *  Per RSS 2.0 specification, it is the "item synopsis."
 */
@property (nonatomic, copy) NSString *itemDescription;

/**
 *  This property corresponds to the `author` element within an `item` element.
 *  
 *  Per RSS 2.0 specification, it is the "email address of the author of the item."
 */
@property (nonatomic, copy) NSString *authorEmail;

/**
 *  This property corresponds to the `comments` element within an `item` element.
 *
 *  Per RSS 2.0 specification, it is the "URL of a page for comments relating to the item."
 */
@property (nonatomic, copy) NSURL *commentsURL;

/**
 *  This property corresponds to the `guid` element within an `item` element.
 *  
 *  Per RSS 2.0 specification, it is "a string that uniquely identifies the item."
 */
@property (nonatomic, copy) NSString *guid;

/**
 *  This property corresponds to the `pubDate` element within an `item` element.
 *
 *  Per RSS 2.0 specification, it "indicates when the item was published."
 *
 *  The date format is expected to be `EEE, dd MMM yyyy HH:mm:ss Z`.
 */
@property (nonatomic, copy) NSDate *pubDate;

#pragma mark - Media RSS - Primary Elements
///---------------------
/// @name Media RSS - Primary Elements
///---------------------

/**
 *  This is an array of `RSSMediaContent` objects, corresponding to the `media:content` elements within an `item` element.
 *
 *  This is part of the Media RSS specification, a namespace extension to RSS 2.0.
 *  
 *  Per the Media RSS specification, "this element can be used to publish any type of media."
 */
@property (nonatomic, copy) NSArray *mediaContents;

#pragma mark - Media RSS - Optional Elements
///---------------------
/// @name Media RSS - Optional Elements
///---------------------

/**
 *  This property corresponds to the `media:title` element within an `item` element.
 *  
 *  This is part of the Media RSS specification, a namespace extension to RSS 2.0.
 *
 *  Per the Media RSS specification, it is "the title of the particular media object."
 */
@property (nonatomic, copy) NSString *mediaTitle;

/**
 *  Corresponds to the `media:description` element within an `item` element.
 *  
 *  This is part of the Media RSS specification, a namespace extension to RSS 2.0.
 *  
 *  Per the Media RSS specification, it is a "short description describing the media object typically a sentence in length."
 */
@property (nonatomic, copy) NSString *mediaDescription;

/**
 *  This is an array of `RSSMediaThumbnail` objects, corresponding to the `media:thumbnail` elements within an `item` element.
 *
 *  This is part of the Media RSS specification, a namespace extension to RSS 2.0.
 *
 *  Per the Media RSS specification, it "allows particular images to be used as representative images for the media object. If multiple thumbnails are included, and time coding is not at play, it is assumed that the images are in order of importance."
 */
@property (nonatomic, copy) NSArray *mediaThumbnails;

/**
 *  This is an array of `RSSMediaCredit` objects, corresponding to the `media:credit` elements within an `item` element.
 *
 *  This is part of the Media RSS specification, a namespace extension to RSS 2.0. 
 *
 *  Per the Media RSS specification, it is a "notable entity and the contribution to the creation of the media object."
 */
@property (nonatomic, copy) NSArray *mediaCredits;

/**
 *  Corresponds to the `media:text` element within an `item` element.
 *  
 *  This is part of the Media RSS specification, a namespace extension to RSS 2.0.
 *
 *  Per the Media RSS specification, it "allows the inclusion of a text transcript, closed captioning or lyrics of the media content."
 */
@property (nonatomic, copy) NSString *mediaText;

#pragma mark - Getting Embedded Images
///---------------------
/// @name Getting Embedded Images
///---------------------

/**
 *  Calls `imagesFromHTML:` passing in its `itemDescription` property.
 *
 *  @return An array of `NSString` objects containing links (strings starting within `http` or `https`) to all images from the `itemDescription` property.
 */
- (NSArray *)imagesFromItemDescription;

/**
 *  Calls `imagesFromHTML:` passing in its `mediaText` property.
 *
 *  @return An array of `NSString` objects containing links (strings starting within `http` or `https`) to all images from the `mediaText` property.
 */
- (NSArray *)imagesFromMediaText;

/**
 *  Creates an array of `NSString` objects containing URLs (starting with either `http` or `https` only) to all images from the passed in `html` property. This method uses an `NSRegularExpression` to search for strings matching the format `(https?)\\S*(png|jpg|jpeg|gif)`.
 *
 *  @param html The string to search for images (http(s) links).
 *
 *  @return An array of `NSString` objects containing URLs (strings starting within `http` or `https`) to all images within the passed in `html` string.
 */
- (NSArray *)imagesFromHTML:(NSString *)html;

@end
