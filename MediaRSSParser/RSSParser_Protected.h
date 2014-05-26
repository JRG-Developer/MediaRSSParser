//
//  RSSParser_Protected.h
//  MediaRSSParser
//
//  Created by Joshua Greene on 5/19/14.
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

#import "RSSParser.h"

#import "RSSChannel.h"
#import "RSSItem.h"

#import "RSSMediaContent.h"
#import "RSSMediaThumbnail.h"
#import "RSSMediaCredit.h"

/**
 *  `RSSParser_Protected` contains internal properties used by `RSSParser` that should not be used by other
 *  controllers or classes. These properties are only exposed for unit testing purposes (see `RSSParserTests.m`)
 */

@interface RSSParser ()

///---------------------
/// @name Parse Setup and Completion Properties
///---------------------

/**
 *  The client that handles network requests for the parser.
 */
@property (nonatomic, strong) AFHTTPSessionManager *client;

/**
 *  This property stores a reference to the `NSXMLParser` object returned on network request successful completion.
 *  It allows the parser to be cancelled programmatically (see the `cancel` method on `RSSParser.h`).
 */
@property (nonatomic, strong) NSXMLParser *xmlParser;

/**
 *  This is a copy of the `successBlock` passed to the parser, called only on successful parse completion.
 */
@property (nonatomic, copy) void (^successBlock)(RSSChannel *channel);

/**
 *  This is a copy of the `failBlock` passed on to the parser, called if either a network or parse error occurs.
 */
@property (nonatomic, copy) void (^failblock)(NSError *error);

///---------------------
/// @name Construction Properties Used In NSXMLParserDelegate Methods
///---------------------

/**
 *  The `RSSChannel` object that is being parsed. Per RSS 2.0 specification (see http://cyber.law.harvard.edu/rss/rss.html), an RSS feed should contain a single `channel` element only.
 */

@property (nonatomic, strong) RSSChannel *channel;

/**
 *  The current `RSSItem` object that is being parsed.
 */
@property (nonatomic, strong) RSSItem *currentItem;

/**
 *  The array of `RSSItem` objects that have already been parsed
 */
@property (nonatomic, strong) NSMutableArray *items;

/**
 *  The current array of media contents that is being parsed, ultimately set as `mediaContents` on `currentItem`
 */
@property (nonatomic, strong) NSMutableArray *mediaContents;

/**
 *  The current array of media credits that is being parsed, ultimately set as `mediaCredits` on `currentItem`
 */
@property (nonatomic, strong) NSMutableArray *mediaCredits;

/**
 *  The current array of media thumbails that is being parsed, ultimately set as `mediaThumbnails` on `currentItem`
 */
@property (nonatomic, strong) NSMutableArray *mediaThumbnails;

/**
 *  The temporary, builder string that characters are added to as the parser encounters them.
 */
@property (nonatomic, strong) NSMutableString *tempString;

/**
 *  This method is called on successful GET response. This method is exposed only for testing purposes.
 */
- (void)GETSucceeded:(NSXMLParser *)responseObject;

@end
