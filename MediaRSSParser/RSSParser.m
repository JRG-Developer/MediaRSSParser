//
//  RSSParser.m
//  RSSParser
//
//  Modified by Joshua Greene on 4/2/14 (added support for Media RSS).
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

@implementation RSSParser

#pragma mark - Object Lifecycle

- (instancetype)init {
  self = [super init];
  if (self) {    
    [self setUpClient];
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

#pragma mark - Parse

+ (RSSParser *)parseRSSFeed:(NSString *)urlString
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(NSArray *feedItems))success
                    failure:(void (^)(NSError *error))failure
{
  RSSParser *parser = [[RSSParser alloc] init];
  [parser parseRSSFeed:urlString parameters:parameters success:success failure:failure];
  return parser;
}

- (void)parseRSSFeed:(NSString *)urlString
          parameters:(NSDictionary *)parameters
             success:(void (^)(NSArray *feedItems))success
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

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
  self.items = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
  [self.tmpString appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
  if (self.successBlock) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.successBlock(self.items);
      [self nilSuccessAndFailureBlocks];
    });
  }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
  [parser abortParsing];
  
  if (self.failblock) {
    self.failblock(parseError);
  }
  
  [self nilSuccessAndFailureBlocks];
}

#pragma mark - NSXMLParserDelegate - didStartElement

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
  if ([self matchesItemElement:elementName]) {
    [self startNewItem];
    
  } else if ([self matchesMediaCreditElement:elementName]) {
    [self addMediaCreditFromAttributes:attributeDict];
    
  } else if ([self matchesMediaThumbnailElement:elementName]) {
    [self addMediaThumbnailFromAttributes:attributeDict];
    
  } else if ([self matchesMediaContentElement:elementName]) {
    [self addMediaContentFromAttributes:attributeDict];
    
  }
  
  self.tmpString = [[NSMutableString alloc] init];
}

- (void)startNewItem
{
  self.currentItem = [[RSSItem alloc] init];
  self.mediaCredits = [[NSMutableArray alloc] init];
  self.mediaThumbnails = [[NSMutableArray alloc] init];
  self.mediaContents = [[NSMutableArray alloc] init];
}

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

- (void)addMediaThumbnailFromAttributes:(NSDictionary *)attributes
{
  RSSMediaItem *mediaItem = [self mediaItemFromAttributes:attributes];
  [self.mediaThumbnails addObject:mediaItem];
}

- (void)addMediaContentFromAttributes:(NSDictionary *)attributes
{
  RSSMediaItem *mediaItem = [self mediaItemFromAttributes:attributes];
  [self.mediaContents addObject:mediaItem];
}

- (RSSMediaItem *)mediaItemFromAttributes:(NSDictionary *)attributes
{
  RSSMediaItem *mediaThumbnail = [[RSSMediaItem alloc] init];
  mediaThumbnail.url = [NSURL URLWithString:attributes[@"url"]];
  mediaThumbnail.size = CGSizeMake([attributes[@"height"] floatValue], [attributes[@"width"] floatValue]);
  return mediaThumbnail;
}

#pragma mark - Start Matchers

- (BOOL)matchesItemElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"];
}

- (BOOL)matchesMediaCreditElement:(NSString *)elementName
{
  return [elementName isEqual:@"media:credit"];
}

- (BOOL)matchesMediaThumbnailElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"media:thumbnail"];
}

- (BOOL)matchesMediaContentElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"media:content"];
}

#pragma mark - NSXMLParserDelegate - didEndElement

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  if ([self matchesItemElement:elementName]) {
    [self endCurrentItem];
    
  } else if (self.currentItem != nil && self.tmpString != nil) {
    
    if ([self matchesTitleElement:elementName]) {
      [self.currentItem setTitle:self.tmpString];
      
    } else if ([self matchesItemDescriptionElement:elementName]) {
      [self.currentItem setItemDescription:self.tmpString];
      
    } else if ([self matchesContentElement:elementName]) {
      [self.currentItem setContent:self.tmpString];
      
    } else if ([self matchesLinkElement:elementName]) {
      [self.currentItem setLink:[NSURL URLWithString:self.tmpString]];
      
    } else if ([self matchesCommentsLinkElement:elementName]) {
      [self.currentItem setCommentsLink:[NSURL URLWithString:self.tmpString]];
      
    } else if ([self matchesCommentsFeedElement:elementName]) {
      [self.currentItem setCommentsFeed:[NSURL URLWithString:self.tmpString]];
      
    } else if ([self matchesCommentsCountElement:elementName]) {
      [self.currentItem setCommentsCount:[NSNumber numberWithInt:[self.tmpString intValue]]];
      
    } else if ([self matchesPubDateElement:elementName]) {
      [self setPubDate];
      
    } else if ([self matchesAuthorElement:elementName]) {
      [self.currentItem setAuthor:self.tmpString];
      
    } else if ([self matchesGuidElement:elementName]) {
      [self.currentItem setGuid:self.tmpString];
      
    } else if ([self matchesMediaTitleElement:elementName]) {
      [self.currentItem setMediaTitle:self.tmpString];
      
    } else if ([self matchesMediaDescriptionElement:elementName]) {
      [self.currentItem setMediaDescription:self.tmpString];
      
    } else if ([self matchesMediaTextElement:elementName]) {
      [self.currentItem setMediaText:self.tmpString];
      
    } else if ([self matchesMediaCreditElement:elementName]) {
      [self setMediaCreditValue];
      
    }
  }
}

- (void)endCurrentItem
{
  self.currentItem.mediaCredits = [self.mediaCredits copy];
  self.currentItem.mediaThumbnails = [self.mediaThumbnails copy];
  self.currentItem.mediaContents = [self.mediaContents copy];
  [self.items addObject:self.currentItem];
}

- (void)setPubDate
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
  [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"]];
  [self.currentItem setPubDate:[formatter dateFromString:self.tmpString]];
}

- (void)setMediaCreditValue
{
  RSSMediaCredit *mediaCredit = [self.currentItem.mediaCredits lastObject];
  [mediaCredit setValue:self.tmpString];
}

#pragma mark - End Matchers

- (BOOL)matchesTitleElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"title"];
}

- (BOOL)matchesItemDescriptionElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"description"];
}

- (BOOL)matchesContentElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"content:encoded"] || [elementName isEqualToString:@"content"];
}

- (BOOL)matchesLinkElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"link"];
}

- (BOOL)matchesCommentsLinkElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"comments"];
}

- (BOOL)matchesCommentsFeedElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"wfw:commentRss"];
}

- (BOOL)matchesCommentsCountElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"slash:comments"];
}

- (BOOL)matchesPubDateElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"pubDate"];
}

- (BOOL)matchesAuthorElement:(NSString *)elementName
{
  return [elementName isEqualToString:@"dc:creator"];
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
