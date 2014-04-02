//
//  RSSParser.h
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface RSSParser : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong) AFHTTPSessionManager *client;
@property (nonatomic, strong) NSXMLParser *xmlParser;

+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForURLString:(NSString *)urlString
                         success:(void (^)(NSArray *feedItems))success
                         failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForURL:(NSURL *)url
                   success:(void (^)(NSArray *feedItems))success
                   failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForURLString:(NSString *)urlString
                      parameters:(NSDictionary *)paremeters
                         success:(void (^)(NSArray *feedItems))success
                         failure:(void (^)(NSError *error))failure;
- (void)cancel;

@end
