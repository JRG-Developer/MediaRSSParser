//
//  Test_RSSParser.m
//  MediaRSSParser
//
//  Created by Joshua Greene on 5/22/14.
//  Copyright (c) 2014 App-Order, LLC. All rights reserved.
//

#import "Test_RSSParser.h"
#import "RSSParser_Protected.h"

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@implementation Test_RSSParser

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.parserCopyMock = mock([RSSParser class]);
  }
  return self;
}

- (void)setSuccessBlock:(void (^)(NSArray *))successBlock
{
  [super setSuccessBlock:successBlock];
  [self.parserCopyMock setSuccessBlock:successBlock];
}

- (void)setFailblock:(void (^)(NSError *))failblock
{
  [super setFailblock:failblock];
  [self.parserCopyMock setFailblock:failblock];
}

@end
