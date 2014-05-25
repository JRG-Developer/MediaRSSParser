//
//  RSSParser+TestMethods.m
//  MediaRSSParser
//
//  Created by Joshua Greene on 5/22/14.
//  Copyright (c) 2014 App-Order, LLC. All rights reserved.
//

#import "RSSParser+TestMethods.h"
#import <objc/runtime.h>

@implementation RSSParser (TestMethods)

- (void)test_parseRSSFeed:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(NSArray *))success
                  failure:(void (^)(NSError *))failure
{
  NSNumber *number = @YES;
  objc_setAssociatedObject(self, &RSSParseRSSFeedKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)calledParseRSSFeed
{
  NSNumber *number = objc_getAssociatedObject(self, &RSSParseRSSFeedKey);
  return [number boolValue];
}

- (void)test_cancel
{
  NSNumber *number = @YES;
  objc_setAssociatedObject(self, &RSSParserCancelKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)calledCancel
{
  NSNumber *number = objc_getAssociatedObject(self, &RSSParserCancelKey);
  return [number boolValue];
}

@end
