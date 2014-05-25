//
//  RSSParser+TestMethods.h
//  MediaRSSParser
//
//  Created by Joshua Greene on 5/22/14.
//  Copyright (c) 2014 App-Order, LLC. All rights reserved.
//

#import "RSSParser.h"

const char RSSParseRSSFeedKey;
const char RSSParserCancelKey;

@interface RSSParser (TestMethods)

- (void)test_parseRSSFeed:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSError *))failure;

- (BOOL)calledParseRSSFeed;

- (void)test_cancel;
- (BOOL)calledCancel;

@end
