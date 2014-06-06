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
#import <AOTestCase/AOTestCase.h>
#import "RSSParser+TestMethods.h"

#import <objc/runtime.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

const char RSSParserFailBlockKey;

@interface RSSParserTests : AOTestCase
@end

@implementation RSSParserTests
{
  Test_RSSParser *sut;

  NSDateFormatter *dateFormatter;
  RSSChannel *testChannel;
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

#pragma mark - Data

- (NSString *)fileURLPathForRSS2Example
{
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"RSS_2_Example" withExtension:@"xml"];
  return [url absoluteString];
}

- (NSString *)fileURLPathForMediaRSSExample
{
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"Media_RSS_Example" withExtension:@"xml"];
  return [url absoluteString];
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

#pragma mark - Utilities

- (void)setUpDateFormatter
{
  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
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
  [self swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
  
  // when
  RSSParser *parser = [RSSParser parseRSSFeed:@"" parameters:nil success:nil failure:nil];
  
  // then
  assertThatBool([parser calledParseRSSFeed], equalToBool(YES));
  
  // clean up
  [self swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
}

#pragma mark - Instance Method - Parse - Tests

- (void)test___parseRSSFeed_paramemters_success_failure___calls_cancel
{
  // given
  SEL selector = @selector(cancel);
  SEL testSelector = @selector(test_cancel);
  [self swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
  
  // when
  [sut parseRSSFeed:@"" parameters:nil success:nil failure:nil];
  
  // then
  assertThatBool([sut calledCancel], equalToBool(YES));
  
  // clean up
  [sut cancel];
  [self swapInstanceMethodsForClass:[RSSParser class] selector:selector andSelector:testSelector];
}

- (void)test___parseRSSFeed_paramemters_success_failure___sets_success_block
{
  // given
  void (^success)(RSSChannel *) = ^(RSSChannel *channel) { };
  
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

#pragma mark - Parsing - RSS 2.0

- (void)test__parseRSSFeed_paramemters_success_failure___correctly_parses_RSS_2
{
  [self beginAsynchronousOperation];
  
  [sut parseRSSFeed:[self fileURLPathForRSS2Example] parameters:nil success:^(RSSChannel *channel) {

    [self endAsynchronousOperation];
    
    testChannel = channel;
    [self verifyRSS2];
    
  } failure:^(NSError *error) {
    XCTAssertTrue(NO, @"Error:%@", error);
    [self endAsynchronousOperation];
    
  }];
  
  [self waitForAsyncronousOperation];
}

- (void)verifyRSS2
{
  [self setUpDateFormatter];
  [self verifyRSS2_channelProperties];
  [self verifyRSS2_Empty_Item1];
  [self verifyRSS2_Item2];
  [self verifyRSS2_Item3];
}

- (void)verifyRSS2_channelProperties
{
  assertThat(testChannel.title, equalTo(@"RSS 2.0 Example"));
  assertThat([testChannel.link absoluteString], equalTo(@"http://www.example.com"));
  assertThat(testChannel.channelDescription, equalTo(@"RSS 2.0 Example XML"));
  assertThat(testChannel.language, equalTo(@"en-us"));
  assertThat(testChannel.copyright, equalTo(@"Copyright 2014 Example, Inc."));
  assertThat(testChannel.managingEditorEmail, equalTo(@"editor@example.com"));
  assertThat(testChannel.webMasterEmail, equalTo(@"webmaster@example.com"));
  assertThat(testChannel.pubDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 11:00:00 GMT"]));
  assertThat(testChannel.lastBuildDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 12:00:00 GMT"]));
  assertThat(testChannel.generator, equalTo(@"Example Editor 2.0"));
  assertThat([testChannel.docsURL absoluteString], equalTo(@"http://blogs.law.harvard.edu/tech/rss"));
  assertThatInt(testChannel.ttl, equalToInt(60));

  assertThatInt(testChannel.items.count, equalToInt(3));
}

- (void)verifyRSS2_Empty_Item1
{
  RSSItem *item1 = testChannel.items[0];
  assertThat(item1.title, nilValue());
  assertThat(item1.link, nilValue());
  assertThat(item1.itemDescription, nilValue());
  assertThat(item1.authorEmail, nilValue());
  assertThat(item1.commentsURL, nilValue());
  assertThat(item1.guid, nilValue());
  assertThat(item1.pubDate, nilValue());
}

- (void)verifyRSS2_Item2
{
  RSSItem *item2 = testChannel.items[1];
  assertThat(item2.title, equalTo(@"Item 2 Title"));
  assertThat([item2.link absoluteString], equalTo(@"http://www.example.com/item2"));
  assertThat(item2.itemDescription, equalTo(@"Item 2 Description"));
  assertThat(item2.authorEmail, equalTo(@"author2@example.com"));
  assertThat([item2.commentsURL absoluteString], equalTo(@"http://www.example.com/item2/comments"));
  assertThat(item2.guid, equalTo(@"Item#0002"));
  assertThat(item2.pubDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 02:00:00 GMT"]));
}

- (void)verifyRSS2_Item3
{
  RSSItem *item3 = testChannel.items[2];
  assertThat(item3.title, equalTo(@"Item 3 Title"));
  assertThat([item3.link absoluteString], equalTo(@"http://www.example.com/item3"));
  assertThat(item3.itemDescription, equalTo(@"Item 3 Description"));
  assertThat(item3.authorEmail, equalTo(@"author3@example.com"));
  assertThat([item3.commentsURL absoluteString], equalTo(@"http://www.example.com/item3/comments"));
  assertThat(item3.guid, equalTo(@"Item#0003"));
  assertThat(item3.pubDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 03:00:00 GMT"]));
}

#pragma mark - Parsing - Media RSS 1.5.1

- (void)test__parseRSSFeed_paramemters_success_failure___correctly_parses_Media_RSS
{
  [self beginAsynchronousOperation];
  
  [sut parseRSSFeed:[self fileURLPathForMediaRSSExample] parameters:nil success:^(RSSChannel *channel) {
    
    testChannel = channel;
    [self verifyMediaRSS];
    
    [self endAsynchronousOperation];
    
  } failure:^(NSError *error) {
    XCTAssertTrue(NO, @"Error:%@", error);

    [self endAsynchronousOperation];
  }];
  
  [self waitForAsyncronousOperation];
}

- (void)verifyMediaRSS
{
  [self setUpDateFormatter];
  
  [self verifyMediaRSS_channelProperties];
  [self verifyMediaRSS_Item1];
  [self verifyMediaRSS_Item2];
}

- (void)verifyMediaRSS_channelProperties
{
  assertThat(testChannel.title, equalTo(@"Media RSS Example"));
  assertThat([testChannel.link absoluteString], equalTo(@"http://www.media.example.com"));
  assertThat(testChannel.channelDescription, equalTo(@"Media RSS Example XML"));
  assertThat(testChannel.language, equalTo(@"en-us"));
  assertThat(testChannel.copyright, equalTo(@"Copyright 2014 Media Example, Inc."));
  assertThat(testChannel.managingEditorEmail, equalTo(@"media.editor@example.com"));
  assertThat(testChannel.webMasterEmail, equalTo(@"media.webmaster@example.com"));
  assertThat(testChannel.pubDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 02:00:00 GMT"]));
  assertThat(testChannel.lastBuildDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 03:00:00 GMT"]));
  assertThat(testChannel.generator, equalTo(@"Media Example Editor 2.0"));
  assertThat([testChannel.docsURL absoluteString], equalTo(@"http://blogs.law.harvard.edu/tech/rss"));
  assertThatInt(testChannel.ttl, equalToInt(45));
  
  assertThatInt(testChannel.items.count, equalToInt(2));
}

- (void)verifyMediaRSS_Item1
{
  [self verifyMediaRSS_Item1_Properties];

  [self verifyMediaRSS_Item1_Empty_MediaContent1];
  [self verifyMediaRSS_Item1_MediaContent2];
  
  [self verifyMediaRSS_Item1_Empty_MediaThumbnail1];
  [self verifyMediaRSS_Item1_MediaThumbnail2];
  
  [self verifyMediaRSS_Item1_Empty_MediaCredit1];
  [self verifyMediaRSS_Item1_MediaCredit2];
}

- (void)verifyMediaRSS_Item1_Properties
{
  RSSItem *item1 = testChannel.items[0];
  
  assertThat(item1.title, equalTo(@"Media Item 1 Title"));
  assertThat([item1.link absoluteString], equalTo(@"http://www.example.com/media-item1"));
  assertThat(item1.itemDescription, equalTo(@"Media Item 1 Description"));
  assertThat(item1.authorEmail, equalTo(@"media.author1@example.com"));
  assertThat([item1.commentsURL absoluteString], equalTo(@"http://www.example.com/media-item1/comments"));
  assertThat(item1.guid, equalTo(@"Media-Item#0001"));
  assertThat(item1.pubDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 01:00:00 GMT"]));
  
  assertThat(item1.mediaTitle, equalTo(@"Media Title 1"));
  assertThat(item1.mediaDescription, equalTo(@"Media Description 1"));
  assertThat(item1.mediaText, equalTo(@"Media Text 1"));
  
  assertThatInt(item1.mediaContents.count, equalToInt(2));
  assertThatInt(item1.mediaThumbnails.count, equalToInt(2));
  assertThatInt(item1.mediaCredits.count, equalToInt(2));
}

- (void)verifyMediaRSS_Item1_Empty_MediaContent1
{
  RSSItem *item1 = testChannel.items[0];
  
  RSSMediaContent *mediaContent = item1.mediaContents[0];
  assertThat(mediaContent.url, nilValue());
  assertThatInt(mediaContent.fileSize, equalToInt(0));
  assertThat(mediaContent.type, nilValue());
  assertThat(mediaContent.medium, nilValue());
  assertThatBool(mediaContent.isDefault, equalToBool(NO));
  assertThat(mediaContent.expression, nilValue());
  assertThatInt(mediaContent.bitrate, equalToInt(0));
  assertThatInt(mediaContent.framerate, equalToInt(0));
  assertThatFloat(mediaContent.samplingRate, equalToFloat(0.0f));
  assertThatInt(mediaContent.channels, equalToInt(0));
  assertThatInt(mediaContent.duration, equalToInt(0));
  assertThatFloat(mediaContent.size.height, equalToFloat(0.0f));
  assertThatFloat(mediaContent.size.width, equalToFloat(0.0f));
  assertThat(mediaContent.language, nilValue());
}

- (void)verifyMediaRSS_Item1_MediaContent2
{
  RSSItem *item1 = testChannel.items[0];
  
  RSSMediaContent *mediaContent = item1.mediaContents[1];
  assertThat([mediaContent.url absoluteString], equalTo(@"http://www.example.com/movie1.mov"));
  assertThatInt(mediaContent.fileSize, equalToInt(12216320));
  assertThat(mediaContent.type, equalTo(@"video/quicktime"));
  assertThat(mediaContent.medium, equalTo(@"video"));
  assertThatBool(mediaContent.isDefault, equalToBool(YES));
  assertThat(mediaContent.expression, equalTo(@"full"));
  assertThatInt(mediaContent.bitrate, equalToInt(128));
  assertThatInt(mediaContent.framerate, equalToInt(25));
  assertThatFloat(mediaContent.samplingRate, equalToFloat(44.1f));
  assertThatInt(mediaContent.channels, equalToInt(2));
  assertThatInt(mediaContent.duration, equalToInt(185));
  assertThatFloat(mediaContent.size.height, equalToFloat(200.0f));
  assertThatFloat(mediaContent.size.width, equalToFloat(300.0f));
  assertThat(mediaContent.language, equalTo(@"en"));
}

- (void)verifyMediaRSS_Item1_Empty_MediaThumbnail1
{
  RSSItem *item1 = testChannel.items[0];

  RSSMediaThumbnail *thumb1 = item1.mediaThumbnails[0];
  assertThat(thumb1.url, nilValue());
  assertThatFloat(thumb1.size.height, equalToFloat(0));
  assertThatFloat(thumb1.size.width, equalToFloat(0));
  assertThat(thumb1.timeOffset, nilValue());
}

- (void)verifyMediaRSS_Item1_MediaThumbnail2
{
  RSSItem *item1 = testChannel.items[0];
  
  RSSMediaThumbnail *thumb2 = item1.mediaThumbnails[1];
  assertThat([thumb2.url absoluteString], equalTo(@"http://www.example.com/thumbnails/movie1-01"));
  assertThatFloat(thumb2.size.height, equalToFloat(50));
  assertThatFloat(thumb2.size.width, equalToFloat(75));
  assertThat(thumb2.timeOffset, equalTo(@"0:0:22.0"));
}

- (void)verifyMediaRSS_Item1_Empty_MediaCredit1
{
  RSSItem *item1 = testChannel.items[0];
  
  RSSMediaCredit *credit1 = item1.mediaCredits[0];
  assertThat(credit1.role, nilValue());
  assertThat(credit1.value, nilValue());
}

- (void)verifyMediaRSS_Item1_MediaCredit2
{
  RSSItem *item1 = testChannel.items[0];
  
  RSSMediaCredit *credit2 = item1.mediaCredits[1];
  assertThat(credit2.role, equalTo(@"co-artist"));
  assertThat(credit2.value, equalTo(@"Bob Artist"));
}

- (void)verifyMediaRSS_Item2
{
  [self verifyMediaRSS_Item2_Properties];
  [self verifyMediaRSS_Item2_Empty_MediaContent1];
  [self verifyMediaRSS_Item2_Minimum_Values_MediaContent2];
}

- (void)verifyMediaRSS_Item2_Properties
{
  RSSItem *item2 = testChannel.items[1];
  assertThat(item2.title, equalTo(@"Media Item 2 Title"));
  assertThat([item2.link absoluteString], equalTo(@"http://www.example.com/media-item2"));
  assertThat(item2.itemDescription, equalTo(@"Media Item 2 Description"));
  assertThat(item2.authorEmail, equalTo(@"media.author2@example.com"));
  assertThat([item2.commentsURL absoluteString], equalTo(@"http://www.example.com/media-item2/comments"));
  assertThat(item2.guid, equalTo(@"Media-Item#0002"));
  assertThat(item2.pubDate, equalTo([dateFormatter dateFromString:@"Tue, 10 Jun 2003 02:00:00 GMT"]));
  assertThatInt(item2.mediaContents.count, equalToInt(2));
  
  assertThat(item2.mediaTitle, equalTo(@"Media Title 2"));
  assertThat(item2.mediaDescription, equalTo(@"Media Description 2"));
  assertThat(item2.mediaText, equalTo(@"Media Text 2"));
  
  assertThatInt(item2.mediaContents.count, equalToInt(2));
}

- (void)verifyMediaRSS_Item2_Empty_MediaContent1
{
  RSSItem *item2 = testChannel.items[1];
  
  RSSMediaContent *mediaContent1 = item2.mediaContents[0];
  assertThat([mediaContent1.url absoluteString], nilValue());
  assertThatFloat(mediaContent1.size.height, equalToFloat(0.0f));
  assertThatFloat(mediaContent1.size.width, equalToFloat(0.0f));
  assertThatInt(mediaContent1.fileSize, equalToInt(0));
  assertThat(mediaContent1.type, nilValue());
  assertThat(mediaContent1.medium, nilValue());
  assertThatBool(mediaContent1.isDefault, equalToBool(NO));
  assertThat(mediaContent1.expression, nilValue());
  assertThatInt(mediaContent1.bitrate, equalToInt(0));
  assertThatInt(mediaContent1.framerate, equalToInt(0));
  assertThatFloat(mediaContent1.samplingRate, equalToFloat(0.0f));
  assertThatInt(mediaContent1.channels, equalToInt(0));
  assertThatInt(mediaContent1.duration, equalToInt(0));
  assertThat(mediaContent1.language, nilValue());
}

- (void)verifyMediaRSS_Item2_Minimum_Values_MediaContent2
{
  RSSItem *item2 = testChannel.items[1];
  RSSMediaContent *mediaContent2 = item2.mediaContents[1];
  assertThat([mediaContent2.url absoluteString], equalTo(@"http://www.example.com/image.jpg"));
  assertThatFloat(mediaContent2.size.height, equalToFloat(1000.0f));
  assertThatFloat(mediaContent2.size.width, equalToFloat(1500.0f));
}


@end