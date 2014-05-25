//
//  RSSParserTests.m
//  MediaRSSParser
//
//  Created by Joshua Greene on 5/22/14.
//  Copyright (c) 2014 App-Order, LLC. All rights reserved.
//

// Test Class
#import "Test_RSSParser.h"
#import "RSSParser_Protected.h"

// Collaborators
#import <AFNetworking/AFHTTPSessionManager.h>

// Test Support
#import "RSSTestCase.h"
#import "RSSParser+TestMethods.h"

#import <objc/runtime.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

const char RSSParserFailBlockKey;

@interface RSSParserTests : RSSTestCase
@end

@implementation RSSParserTests
{
  Test_RSSParser *sut;
}

#pragma mark - Test Lifecycle

- (void)setUp
{
  [super setUp];
  sut = [[Test_RSSParser alloc] init];
}

#pragma mark - Given

- (void)givenMockClientNumberOfTasks:(NSUInteger)count
{
  AFHTTPSessionManager *client = mock([AFHTTPSessionManager class]);
  [given([client tasks]) willReturn:[self mockNumberOfTasks:count]];
  
  sut.client = client;
}

- (NSArray *)mockNumberOfTasks:(NSUInteger)count
{
  NSMutableArray *tasks = [NSMutableArray arrayWithCapacity:count];
  
  for (NSInteger i = 0; i < count; i ++) {
    [tasks addObject:mock([NSURLSessionTask class])];
  }
  
  return [tasks copy];
}

#pragma mark - When

- (NSXMLParser *)whenGETSucceeded
{
  // given
  NSXMLParser *mockXMLParser = mock([NSXMLParser class]);
  
  // when
  [sut GETSucceeded:mockXMLParser];
  
  return mockXMLParser;
}

#pragma mark - Verify

- (void)verifySuccessBlockSetAsNil
{
  [verify(sut.parserCopyMock) setSuccessBlock:nil];
}

- (void)verifyFailBlockSetAsNil
{
  [verify(sut.parserCopyMock) setFailblock:nil];
}

#pragma mark - Init - Tests

- (void)test___init___initializes_client
{
  assertThat(sut.client, notNilValue());
}

- (void)test___init___sets_client_responseSerializer
{
  XCTAssertTrue([sut.client.responseSerializer isKindOfClass:[AFXMLParserResponseSerializer class]]);
}

- (void)test___init___sets_client_responseSerialier_acceptableContentTypes
{
  NSSet *set = sut.client.responseSerializer.acceptableContentTypes;
  XCTAssertTrue([set containsObject:@"application/xml"]);
  XCTAssertTrue([set containsObject:@"text/xml"]);
  XCTAssertTrue([set containsObject:@"application/rss+xml"]);
  XCTAssertTrue([set containsObject:@"application/atom+xml"]);
}

#pragma mark - Cancel - Tests

- (void)test___cancel___aborts_parsing
{
  // given
  sut.xmlParser = mock([NSXMLParser class]);
  
  // when
  [sut cancel];
  
  // then
  [verify(sut.xmlParser) abortParsing];
}

- (void)test___cancel___cancels_all_tasks
{
  // given
  NSUInteger count = 3;
  [self givenMockClientNumberOfTasks:count];
  
  // when
  [sut cancel];
  
  // then
  for (NSUInteger i = 0; i < count; i++) {
    NSURLSessionTask *mockTask = sut.client.tasks[i];
    [verify(mockTask) cancel];
  }
}

- (void)test___cancel___nils_success_block
{
  // when
  [sut cancel];
  
  // then
  [self verifySuccessBlockSetAsNil];
}

- (void)test___cancel___nils_failure_block
{
  // when
  [sut cancel];
  
  // then
  [self verifyFailBlockSetAsNil];
}

#pragma mark - Class Method - Parse - Tests

- (void)test_class_method___parseRSSFeed_paramemters_success_failure___returns_RSSParser_instance
{
  // given
  RSSParser *parser = [RSSParser parseRSSFeed:@"" parameters:nil success:nil failure:nil];
  
  // then
  assertThat(parser, notNilValue());
  
  // cleanup
  [parser cancel];
}

- (void)test_class_method___parseRSSFeed_paramemters_success_failure___calls_instance_methods
{
  // given
  SEL selector = @selector(parseRSSFeed:parameters:success:failure:);
  SEL testSelector = @selector(test_parseRSSFeed:parameters:success:failure:);
  [RSSTestCase swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
  
  // when
  RSSParser *parser = [RSSParser parseRSSFeed:@"" parameters:nil success:nil failure:nil];
  
  // then
  assertThatBool([parser calledParseRSSFeed], equalToBool(YES));
  
  // clean up
  [RSSTestCase swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
}

#pragma mark - Instance Method - Parse - Tests

- (void)test___parseRSSFeed_paramemters_success_failure___calls_cancel
{
  // given
  SEL selector = @selector(cancel);
  SEL testSelector = @selector(test_cancel);
  [RSSTestCase swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
  
  // when
  [sut parseRSSFeed:@"" parameters:nil success:nil failure:nil];
  
  // then
  assertThatBool([sut calledCancel], equalToBool(YES));
  
  // clean up
  [sut cancel];
  [RSSTestCase swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
}

- (void)test___parseRSSFeed_paramemters_success_failure___sets_success_block
{
  // given
  void (^success)(NSArray *) = ^(NSArray *feeditems) { };
  
  // when
  [sut parseRSSFeed:@"" parameters:nil success:success failure:nil];
  
  // then
  assertThat(sut.successBlock, equalTo(success));
  
  // clean up
  [sut cancel];
}

- (void)test___parseRSSFeed_paramemters_success_failure___sets_fail_block
{
  // given
  void (^failure)(NSError *) = ^(NSError *error) { };
  
  // when
  [sut parseRSSFeed:@"" parameters:nil success:nil failure:failure];
  
  // then
  assertThat(sut.failblock, equalTo(failure));
  
  // clean up
  [sut cancel];
}

- (void)test___parseRSSFeed_paramemters_success_failure___calls_GET_passing_parameters
{
  // given
  [self givenMockClientNumberOfTasks:0];
  NSString *urlString = @"";
  NSDictionary *parameters = @{};
  
  // when
  
  [sut parseRSSFeed:urlString parameters:parameters success:nil failure:nil];

  // then
  [verify(sut.client) GET:urlString
               parameters:parameters
                  success:anything()
                  failure:anything()];
  
  // clean up
  [sut cancel];
}

- (void)test___parseRSSFeed_parameters_success_failure___success_sets_xmlParser
{
  // when
  NSXMLParser* mockXMLParser = [self whenGETSucceeded];
  
  // then
  assertThat(sut.xmlParser, equalTo(mockXMLParser));
}

- (void)test___parseRSSFeed_parameters_success_failure___success_sets_delegate
{
  // when
  [self whenGETSucceeded];
  
  // then
  [verify(sut.xmlParser) setDelegate:sut];
}

- (void)test___parseRSSFeed_parameters_success_failure___success_starts_parse
{
  // when
  [self whenGETSucceeded];
  
  // then
  [verify(sut.xmlParser) parse];
}

#pragma mark - Instance Methods - NSXMLParserDelegate - Tests

- (void)test___parser_parseErrorOccurred___abortsParsing
{
  // given
  NSXMLParser *mockParser = mock([NSXMLParser class]);
  
  // when
  [sut parser:mockParser parseErrorOccurred:nil];
  
  // then
  [verify(mockParser) abortParsing];
}

- (void)test___parser_parseErrorOccurred___calls_failBlock
{
  // given
  void (^failBlock)(NSError *) = ^(NSError *error) {
    NSNumber *number = @YES;
    objc_setAssociatedObject(sut, &RSSParserFailBlockKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  };
  [sut setFailblock:failBlock];
  
  // when
  [sut parser:nil parseErrorOccurred:nil];
  
  // then
  NSNumber *number = objc_getAssociatedObject(sut, &RSSParserFailBlockKey);
  assertThatBool([number boolValue], equalToBool(YES));
}

- (void)test___parser_parseErrorOccurred__does_not_crash_if_nil_fail_bloc
{
  // given
  [sut setFailblock:nil];
  
  // then
  XCTAssertNoThrow([sut parser:nil parseErrorOccurred:nil]);
}

- (void)test___parser_parseErrorOccurred__nils_success_block
{
  // when
  [sut parser:nil parseErrorOccurred:nil];
  
  // then
  [self verifySuccessBlockSetAsNil];
}

- (void)test___parser_parseErrorOccurred__nils_fail_block
{
  // when
  [sut parser:nil parseErrorOccurred:nil];
  
  // then
  [self verifyFailBlockSetAsNil];
}

- (void)test__parserDidStartDocument___sets_items_array
{
  // given
  
  // when
  [sut parserDidStartDocument:nil];
  
  // then
  assertThat(sut.items, notNilValue());
  assertThatInt(sut.items.count, equalToInt(0));
}

@end