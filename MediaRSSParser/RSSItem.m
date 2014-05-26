//
//  RSSItem.m
//  RSSParser
//
//  Modified by Joshua Greene on 4/2/14 (added support for Media RSS).
//  Created by Thibaut LE LEVIER on 2/3/12.
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

#import "RSSItem.h"

@implementation RSSItem

#pragma mark - Getting Images from HTML

- (NSArray *)imagesFromItemDescription
{
  return self.itemDescription.length ? [self imagesFromHTML:self.itemDescription] : nil;
}

- (NSArray *)imagesFromMediaText
{
  return self.mediaText.length ? [self imagesFromHTML:self.mediaText] : nil;
}

- (NSArray *)imagesFromHTML:(NSString *)html
{
  NSMutableArray *imagesURLStringArray = [[NSMutableArray alloc] init];
  
  NSError *error;
  
  NSRegularExpression *regex = [NSRegularExpression
                                regularExpressionWithPattern:@"(https?)\\S*(png|jpg|jpeg|gif)"
                                options:NSRegularExpressionCaseInsensitive
                                error:&error];
  
  [regex enumerateMatchesInString:html
                          options:0
                            range:NSMakeRange(0, html.length)
                       usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                         [imagesURLStringArray addObject:[html substringWithRange:result.range]];
                       }];
  
  return [NSArray arrayWithArray:imagesURLStringArray];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super init]) {
    _title = [aDecoder decodeObjectForKey:@"title"];
    _link = [aDecoder decodeObjectForKey:@"link"];
    _itemDescription = [aDecoder decodeObjectForKey:@"itemDescription"];
    _authorEmail = [aDecoder decodeObjectForKey:@"authorEmail"];
    _commentsURL = [aDecoder decodeObjectForKey:@"commentsURL"];
    _guid = [aDecoder decodeObjectForKey:@"guid"];
    _pubDate = [aDecoder decodeObjectForKey:@"pubDate"];
    
    _mediaContents = [aDecoder decodeObjectForKey:@"mediaContents"];
    _mediaTitle = [aDecoder decodeObjectForKey:@"mediaTitle"];
    _mediaDescription = [aDecoder decodeObjectForKey:@"mediaDescription"];
    _mediaCredits = [aDecoder decodeObjectForKey:@"mediaCredits"];
    _mediaThumbnails = [aDecoder decodeObjectForKey:@"mediaThumbnails"];
    _mediaText = [aDecoder decodeObjectForKey:@"mediaText"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.title forKey:@"title"];
  [aCoder encodeObject:self.link forKey:@"link"];
  [aCoder encodeObject:self.itemDescription forKey:@"itemDescription"];
  [aCoder encodeObject:self.authorEmail forKey:@"authorEmail"];
  [aCoder encodeObject:self.commentsURL forKey:@"commentsLink"];
  [aCoder encodeObject:self.guid forKey:@"guid"];
  [aCoder encodeObject:self.pubDate forKey:@"pubDate"];
  
  [aCoder encodeObject:self.mediaContents forKey:@"mediaContents"];
  [aCoder encodeObject:self.mediaTitle forKey:@"mediaTitle"];
  [aCoder encodeObject:self.mediaDescription forKey:@"mediaDescription"];
  [aCoder encodeObject:self.mediaCredits forKey:@"mediaCredits"];
  [aCoder encodeObject:self.mediaThumbnails forKey:@"mediaThumbnails"];
  [aCoder encodeObject:self.mediaText forKey:@"mediaText"];
}

#pragma mark - NSObject Protocol

- (BOOL)isEqual:(RSSItem *)object
{
  return [object isKindOfClass:[self class]] &&
    [object.link.absoluteString isEqualToString:self.link.absoluteString];
}

- (NSUInteger)hash
{
  return [self.link.absoluteString hash];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@: %@>", [self class],
          [self.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

@end
