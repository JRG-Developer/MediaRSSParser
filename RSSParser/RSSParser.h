//
//  RSSParser.h
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSItem.h"

@class AFHTTPRequestOperation;

@interface RSSParser : NSObject <NSXMLParserDelegate> {
    RSSItem *currentItem;
    NSMutableArray *items;
    NSMutableString *tmpString;
    void (^block)(NSArray *feedItems);
    void (^failblock)(NSError *error);
}

@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@property (nonatomic, strong) NSXMLParser *xmlParser;

+ (RSSParser *)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                              success:(void (^)(NSArray *feedItems))success
                              failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure;

- (void)cancel;

@end
