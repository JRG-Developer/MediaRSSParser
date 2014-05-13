//
//  RSSParser.m
//  RSSParser
//
//  Modified by Joshua Greene on 4/2/14 (added basic support for Media RSS).
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

#import "AFURLResponseSerialization.h"
#import "AFHTTPSessionManager.h"

#import "RSSItem.h"
#import "RSSMediaCredit.h"
#import "RSSMediaItem.h"

@interface RSSParser ()
@property (nonatomic, strong) RSSItem *currentItem;
@property (nonatomic, strong) NSMutableArray *mediaCredits;
@property (nonatomic, strong) NSMutableArray *mediaThumbnails;
@property (nonatomic, strong) NSMutableArray *mediaContents;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableString *tmpString;
@property (nonatomic, copy) void (^successBlock)(NSArray *feedItems);
@property (nonatomic, copy) void (^failblock)(NSError *error);
@end

@implementation RSSParser

#pragma mark -
#pragma mark lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        _client = [[AFHTTPSessionManager alloc] init];
        _client.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
        _client.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",
                                                              @"text/xml",@"application/rss+xml",
                                                              @"application/atom+xml", nil];
    }
    return self;
}

#pragma mark -
#pragma mark parser

+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure
{
    RSSParser *parser = [[RSSParser alloc] init];
    [parser parseRSSFeedForRequest:urlRequest success:success failure:failure];
}

- (void)parseRSSFeedForURLString:(NSString *)urlString
                         success:(void (^)(NSArray *feedItems))success
                         failure:(void (^)(NSError *error))failure
{
    [self parseRSSFeedForURLString:urlString
                        parameters:nil
                           success:success
                           failure:failure];
}

- (void)parseRSSFeedForURL:(NSURL *)url
                   success:(void (^)(NSArray *feedItems))success
                   failure:(void (^)(NSError *error))failure
{
    [self parseRSSFeedForURLString:[url absoluteString]
                        parameters:nil
                           success:success
                           failure:failure];
}

- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure
{
    [self parseRSSFeedForURLString:[urlRequest.URL absoluteString]
                        parameters:nil
                           success:success
                           failure:failure];
}

- (void)parseRSSFeedForURLString:(NSString *)urlString
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
                 self.xmlParser = responseObject;
                 [self.xmlParser setDelegate:self];
                 [self.xmlParser parse];
                 
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 failure(error);
             }];
}

- (void)cancel
{
    [self cancelAllTasks];
    [self.xmlParser abortParsing];
}

- (void)cancelAllTasks
{
    for (NSURLSessionTask *task in self.client.tasks) {
        [task cancel];
    }
}

#pragma mark -
#pragma mark NSXMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.items = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
        self.currentItem = [[RSSItem alloc] init];
        self.mediaCredits = [[NSMutableArray alloc] init];
        self.mediaThumbnails = [[NSMutableArray alloc] init];
        self.mediaContents = [[NSMutableArray alloc] init];
        
    } else if ([elementName isEqual:@"media:credit"]) {        
        RSSMediaCredit *currentMediaCredit = [self mediaCreditFromAttributes:attributeDict];
        [self.mediaCredits addObject:currentMediaCredit];
        
    } else if ([elementName isEqualToString:@"media:thumbnail"]) {
        RSSMediaItem *mediaItem = [self mediaItemFromAttributes:attributeDict];
        [self.mediaThumbnails addObject:mediaItem];
        
    } else if ([elementName isEqualToString:@"media:content"]) {
        RSSMediaItem *mediaItem = [self mediaItemFromAttributes:attributeDict];
        [self.mediaContents addObject:mediaItem];
    }
    
    self.tmpString = [[NSMutableString alloc] init];
}

- (RSSMediaCredit *)mediaCreditFromAttributes:(NSDictionary *)attributes
{
    RSSMediaCredit *mediaCredit = [[RSSMediaCredit alloc] init];
    mediaCredit.role = attributes[@"role"];
    return mediaCredit;
}

- (RSSMediaItem *)mediaItemFromAttributes:(NSDictionary *)attributes
{
    RSSMediaItem *mediaThumbnail = [[RSSMediaItem alloc] init];
    mediaThumbnail.url = [NSURL URLWithString:attributes[@"url"]];
    mediaThumbnail.height = [attributes[@"height"] floatValue];
    mediaThumbnail.width = [attributes[@"width"] floatValue];
    return mediaThumbnail;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{    
    if ([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"entry"]) {
        self.currentItem.mediaCredits = self.mediaCredits;
        self.currentItem.mediaThumbnails = self.mediaThumbnails;
        self.currentItem.mediaContent = self.mediaContents;
        [self.items addObject:self.currentItem];
        
    } else if (self.currentItem != nil && self.tmpString != nil) {
        
        if ([elementName isEqualToString:@"title"]) {
            [self.currentItem setTitle:self.tmpString];
            
        } else if ([elementName isEqualToString:@"description"]) {
            [self.currentItem setItemDescription:self.tmpString];
            
        } else if ([elementName isEqualToString:@"content:encoded"] || [elementName isEqualToString:@"content"]) {
            [self.currentItem setContent:self.tmpString];
            
        } else if ([elementName isEqualToString:@"link"]) {
            [self.currentItem setLink:[NSURL URLWithString:self.tmpString]];
            
        } else if ([elementName isEqualToString:@"comments"]) {
            [self.currentItem setCommentsLink:[NSURL URLWithString:self.tmpString]];
            
        } else if ([elementName isEqualToString:@"wfw:commentRss"]) {
            [self.currentItem setCommentsFeed:[NSURL URLWithString:self.tmpString]];
            
        } else if ([elementName isEqualToString:@"slash:comments"]) {
            [self.currentItem setCommentsCount:[NSNumber numberWithInt:[self.tmpString intValue]]];
            
        } else if ([elementName isEqualToString:@"pubDate"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            [formatter setLocale:local];
            [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
            
            [self.currentItem setPubDate:[formatter dateFromString:self.tmpString]];
            
        } else if ([elementName isEqualToString:@"dc:creator"]) {
            [self.currentItem setAuthor:self.tmpString];
            
        } else if ([elementName isEqualToString:@"guid"]) {
            [self.currentItem setGuid:self.tmpString];
            
        } else if ([elementName isEqualToString:@"media:title"]) {
            [self.currentItem setMediaTitle:self.tmpString];
            
        } else if ([elementName isEqualToString:@"media:description"]) {
            [self.currentItem setMediaDescription:self.tmpString];
            
        } else if ([elementName isEqual:@"media:text"]) {
            [self.currentItem setMediaText:self.tmpString];
            
        } else if ([elementName isEqualToString:@"media:credit"]) {
            RSSMediaCredit *mediaCredit = [self.currentItem.mediaCredits lastObject];
            [mediaCredit setValue:self.tmpString];
            
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.tmpString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.failblock(parseError);
    [parser abortParsing];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (self.successBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successBlock(self.items);
        });
    }
}

@end
