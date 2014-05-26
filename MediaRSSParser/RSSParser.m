//
//  RSSParser.m
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

#import "RSSParser.h"
#import "RSSParser_Protected.h"

#import "AFURLResponseSerialization.h"
#import "AFHTTPSessionManager.h"

@interface RSSParser()
@property (nonatomic, strong, readwrite) NSDateFormatter *dateFormatter;
@end

@implementation RSSParser

#pragma mark - Object Lifecycle

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setUpClient];
    [self setUpDateFormatter];
  }
  return self;
}

- (void)setUpClient
{
  _client = [[AFHTTPSessionManager alloc] init];
  
  _client.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
  _client.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",
                                                        @"text/xml",
                                                        @"application/rss+xml",
                                                        @"application/atom+xml",
                                                        nil];
}

- (void)setUpDateFormatter
{
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
}

#pragma mark - Cancel

- (void)cancel
{
  [self cancelAllTasks];
  [self.xmlParser abortParsing];
  [self nilSuccessAndFailureBlocks];
}

- (void)cancelAllTasks
{
  for (NSURLSessionTask *task in self.client.tasks) {
    [task cancel];
  }
}

- (void)nilSuccessAndFailureBlocks
{
  [self setSuccessBlock:nil];
  [self setFailblock:nil];
}

#pragma mark - Starting Parser

+ (RSSParser *)parseRSSFeed:(NSString *)urlString
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(RSSChannel *channel))success
                    failure:(void (^)(NSError *error))failure
{
  RSSParser *parser = [[RSSParser alloc] init];
  [parser parseRSSFeed:urlString parameters:parameters success:success failure:failure];
  return parser;
}

- (void)parseRSSFeed:(NSString *)urlString
          parameters:(NSDictionary *)parameters
             success:(void (^)(RSSChannel *channel))success
             failure:(void (^)(NSError *error))failure
{
  [self cancel];
  [self setSuccessBlock:success];
  [self setFailblock:failure];
  
  [self.client GET:urlString
        parameters:parameters
           success:^(NSURLSessionDataTask *task, NSXMLParser *responseObject) {
             [self GETSucceeded:responseObject];
             
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure) {
               failure(error);
             }
             [self nilSuccessAndFailureBlocks];
           }];
}

- (void)GETSucceeded:(NSXMLParser *)responseObject
{
  self.xmlParser = responseObject;
  [self.xmlParser setDelegate:self];
  [self.xmlParser parse];
}

#pragma mark - NSXMLParserDelegate - Error Handling

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
  [parser abortParsing];
  
  if (self.failblock) {
    self.failblock(parseError);
  }
  
  [self nilSuccessAndFailureBlocks];
}

#pragma mark - NSXMLParserDelegate - Document Start

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
  self.channel = [[RSSChannel alloc] init];
  self.items = [[NSMutableArray alloc] init];
}

#pragma mark - NSXMLParserDelegate - Found Characters

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
  [self.tempString appendString:string];
}

#pragma mark - NSXMLParserDelegate - Document End

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
  [self setChannelProperties];
  [self nilTemporaryProperties];
  [self dispatchSuccess];
}

- (void)setChannelProperties
{
  self.channel.items = self.items;
}

- (void)nilTemporaryProperties
{
  self.currentItem = nil;
  self.mediaCredits = nil;
  self.mediaContents = nil;
  self.mediaThumbnails = nil;
  self.items = nil;
  self.tempString = nil;
}

- (void)dispatchSuccess
{
  if (self.successBlock) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.successBlock(self.channel);
      [self nilSuccessAndFailureBlocks];
    });
  }
}

#pragma mark - NSXMLParserDelegate - Element Start

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
  if ([self matchesItemElement:elementName]) {
    [self startNewItem];
    
  } else if ([self matchesMediaContentElement:elementName]) {
    [self addMediaContentFromAttributes:attributeDict];
    
  } else if ([self matchesMediaThumbnailElement:elementName]) {
    [self addMediaThumbnailFromAttributes:attributeDict];
    
  } else if ([self matchesMediaCreditElement:elementName]) {
    [self addMediaCreditFromAttributes:attributeDict];
    
  }
  
  self.tempString = [[NSMutableString alloc] init];
}

- (void)startNewItem
{
  self.currentItem = [[RSSItem alloc] init];
  
  self.mediaContents = [[NSMutableArray alloc] init];
  self.mediaThumbnails = [[NSMutableArray alloc] init];
  self.mediaCredits = [[NSMutableArray alloc] init];
}

#pragma mark - Start Matchers

- (BOOL)matchesItemElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"];
}

- (BOOL)matchesMediaContentElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"media:content"];
}

- (BOOL)matchesMediaThumbnailElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"media:thumbnail"];
}

- (BOOL)matchesMediaCreditElement:(NSString *)elementName
{
  return [elementName isEqual:@"media:credit"];
}

#pragma mark - Add Media Credit

- (void)addMediaCreditFromAttributes:(NSDictionary *)attributes
{
  RSSMediaCredit *mediaCredit = [self mediaCreditFromAttributes:attributes];
  [self.mediaCredits addObject:mediaCredit];
}

- (RSSMediaCredit *)mediaCreditFromAttributes:(NSDictionary *)attributes
{
  RSSMediaCredit *mediaCredit = [[RSSMediaCredit alloc] init];
  mediaCredit.role = attributes[@"role"];
  return mediaCredit;
}

#pragma mark - Add Media Thumbnail

- (void)addMediaThumbnailFromAttributes:(NSDictionary *)attributes
{
  RSSMediaThumbnail *mediaItem = [self mediaThumbnailFromAttributes:attributes];
  [self.mediaThumbnails addObject:mediaItem];
}

- (RSSMediaThumbnail *)mediaThumbnailFromAttributes:(NSDictionary *)attributes
{
  RSSMediaThumbnail *mediaThumbnail = [[RSSMediaThumbnail alloc] init];
  mediaThumbnail.url = [NSURL URLWithString:attributes[@"url"]];
  mediaThumbnail.size = CGSizeMake([attributes[@"width"] floatValue], [attributes[@"height"] floatValue]);
  mediaThumbnail.timeOffset = attributes[@"time"];
  return mediaThumbnail;
}

#pragma mark - Add Media Content

- (void)addMediaContentFromAttributes:(NSDictionary *)attributes
{
  RSSMediaContent *mediaItem = [self mediaContentFromAttributes:attributes];
  [self.mediaContents addObject:mediaItem];
}

- (RSSMediaContent *)mediaContentFromAttributes:(NSDictionary *)attributes
{
  RSSMediaContent *mediaContent = [[RSSMediaContent alloc] init];
  mediaContent.fileSize = [attributes[@"fileSize"] integerValue];
  mediaContent.type = attributes[@"type"];
  mediaContent.medium = attributes[@"medium"];
  mediaContent.isDefault = [attributes[@"isDefault"] boolValue];
  mediaContent.expression = attributes[@"expression"];
  mediaContent.bitrate = [attributes[@"bitrate"] integerValue];
  mediaContent.framerate = [attributes[@"framerate"] integerValue];
  mediaContent.samplingRate = [attributes[@"samplingrate"] floatValue];
  mediaContent.channels = [attributes[@"channels"] integerValue];
  mediaContent.duration = [attributes[@"duration"] integerValue];
  mediaContent.url = [NSURL URLWithString:attributes[@"url"]];
  mediaContent.size = CGSizeMake([attributes[@"width"] floatValue], [attributes[@"height"] floatValue]);
  mediaContent.language = attributes[@"lang"];
  return mediaContent;
}

#pragma mark - NSXMLParserDelegate - Element End

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  if ([self matchesItemElement:elementName]) {
    [self endCurrentItem];
    
  } else if ([self hasTempString] == NO) {
    return;
    
  } else if ([self hasCurrentItem] == NO) {
    
    if ([self matchesTitleElement:elementName]) {
      [self.channel setTitle:self.tempString];
      
    } else if ([self matchesLinkElement:elementName]) {
      [self.channel setLink:[self urlFromTempString]];
      
    } else if ([self matchesDescriptionElement:elementName]) {
      [self.channel setChannelDescription:self.tempString];
      
    } else if ([self matchesLanguageElement:elementName]) {
      [self.channel setLanguage:self.tempString];
      
    } else if ([self matchesCopyrightElement:elementName]) {
      [self.channel setCopyright:self.tempString];
      
    } else if ([self matchesManagingEditorElement:elementName]) {
      [self.channel setManagingEditorEmail:self.tempString];
      
    } else if ([self matchesWebMasterElement:elementName]) {
      [self.channel setWebMasterEmail:self.tempString];
      
    } else if ([self matchesPubDateElement:elementName]) {
      [self.channel setPubDate:[self dateFromTempString]];
      
    } else if ([self matchesLastBuildDate:elementName]) {
      [self.channel setLastBuildDate:[self dateFromTempString]];
      
    } else if ([self matchesGeneratorElement:elementName]) {
      [self.channel setGenerator:self.tempString];
      
    } else if ([self matchesDocsElement:elementName]) {
      [self.channel setDocsURL:[self urlFromTempString]];
      
    } else if ([self matchesTTLElement:elementName]) {
      [self.channel setTtl:[self integerFromTempString]];
      
    }
    
  } else {
    
    if ([self matchesTitleElement:elementName]) {
      [self.currentItem setTitle:self.tempString];
      
    } else if ([self matchesLinkElement:elementName]) {
      [self.currentItem setLink:[self urlFromTempString]];
      
    } else if ([self matchesDescriptionElement:elementName]) {
      [self.currentItem setItemDescription:self.tempString];
      
    } else if ([self matchesAuthorElement:elementName]) {
      [self.currentItem setAuthorEmail:self.tempString];
      
    } else if ([self matchesCommentsElement:elementName]) {
      [self.currentItem setCommentsURL:[self urlFromTempString]];
      
    } else if ([self matchesGuidElement:elementName]) {
      [self.currentItem setGuid:self.tempString];
      
    } else if ([self matchesPubDateElement:elementName]) {
      self.currentItem.pubDate = [self dateFromTempString];
      
    } else if ([self matchesMediaTitleElement:elementName]) {
      [self.currentItem setMediaTitle:self.tempString];
      
    } else if ([self matchesMediaDescriptionElement:elementName]) {
      [self.currentItem setMediaDescription:self.tempString];
      
    } else if ([self matchesMediaCreditElement:elementName]) {
      [self setMediaCreditValue];
      
    } else if ([self matchesMediaTextElement:elementName]) {
      [self.currentItem setMediaText:self.tempString];
      
    }
  }
}

- (BOOL)hasTempString
{
  return self.tempString.length > 0;
}

- (BOOL)hasCurrentItem
{
  return self.currentItem != nil;
}

- (void)endCurrentItem
{
  self.currentItem.mediaContents = self.mediaContents;
  self.currentItem.mediaThumbnails = self.mediaThumbnails;
  self.currentItem.mediaCredits = self.mediaCredits;
  
  [self.items addObject:self.currentItem];
}

- (NSURL *)urlFromTempString
{
  return [NSURL URLWithString:self.tempString];
}

- (NSDate *)dateFromTempString
{
  return [self.dateFormatter dateFromString:self.tempString];
}

- (NSInteger)integerFromTempString
{
  return [self.tempString integerValue];
}

- (void)setMediaCreditValue
{
  RSSMediaCredit *mediaCredit = [self.mediaCredits lastObject];
  [mediaCredit setValue:self.tempString];
}

#pragma mark - End Matchers

- (BOOL)matchesTitleElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"title"];
}

- (BOOL)matchesLinkElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"link"];
}

- (BOOL)matchesDescriptionElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"description"];
}

- (BOOL)matchesLanguageElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"language"];
}

- (BOOL)matchesCopyrightElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"copyright"];
}

- (BOOL)matchesManagingEditorElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"managingEditor"];
}

- (BOOL)matchesWebMasterElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"webMaster"];
}

- (BOOL)matchesPubDateElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"pubDate"];
}

- (BOOL)matchesLastBuildDate:(NSString *)elementName
{
  return [elementName isEqualToString:@"lastBuildDate"];
}

- (BOOL)matchesGeneratorElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"generator"];
}

- (BOOL)matchesDocsElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"docs"];
}

- (BOOL)matchesTTLElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"ttl"];
}

- (BOOL)matchesAuthorElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"author"];
}

- (BOOL)matchesCommentsElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"comments"];
}

- (BOOL)matchesGuidElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"guid"];
}

- (BOOL)matchesMediaTitleElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"media:title"];
}

- (BOOL)matchesMediaDescriptionElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"media:description"];
}

- (BOOL)matchesMediaTextElement:(NSString *)elementName
{
  return [elementName isEqual:@"media:text"];
}

@end
