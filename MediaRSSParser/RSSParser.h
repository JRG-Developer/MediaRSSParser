//
//  RSSParser.h
//  RSSParser
//
//  Modified by Joshua Greene on 4/2/14.
//  Created by Thibaut LE LEVIER on 1/31/12.
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

@class AFHTTPSessionManager;
@class RSSChannel;

/**
 *  `RSSParser` is a wrapper around an `AFHTTPSessionManager` object, its `client` property, that handles the parsing of Media RSS feed data.
 */
@interface RSSParser : NSObject <NSXMLParserDelegate>

/**
 *  The date formatter used for formatting dates from the RSS feed. This object is created on `init` of the `RSSParser`. If your RSS feed uses an atypical date format, you can set the correct date format on this object. The default date format is `EEE, dd MMM yyyy HH:mm:ss Z`.
 */
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;


/**
 *  This will cancel all of the `NSURLSessionTask` objects of the `client`, call `abortParsing` on `xmlParser`, and set both the `success` and `failure` blocks to `nil` (see `RSSParser_Protected.h` for a description of these internal properties).
 *
 *  Neither the `success` or `failure` block will be called if `cancel` is called (unless, of course, either is called prior to `cancel`).
 */
- (void)cancel;

/**
 *  This is a convenience method for creating a new `RSSParser` object and calling the `parseRSSFeed:parameters:success:failure:` instance method on it.
 */

+ (RSSParser *)parseRSSFeed:(NSString *)urlString
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(RSSChannel *channel))success
                    failure:(void (^)(NSError *error))failure;

/**
 *  This method will initiate a GET request of the given `urlString`, including passing the `parameters`,  using the `client`. Both the `success` and `failure` blocks will be copied as internal properties (see `RSSParser_Protected` for a description of these internal properties).
 *
 *  @param urlString  The URL in string format to GET
 *  @param parameters The parameters to be included in the GET request
 *  @param success    The success block to be called on parser successful completion
 *  @param failure    The failure block to be called on network or parser error

 *  @warning Both the `success` and `failure` blocks capture self (creates a strong references self). This creates a retain cycle until either success or failure results (both `success` and `failure` block are set to `nil` after either occurs).
 *
 */
- (void)parseRSSFeed:(NSString *)urlString
          parameters:(NSDictionary *)parameters
             success:(void (^)(RSSChannel *channel))success
             failure:(void (^)(NSError *error))failure;

@end
