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

- (NSArray *)imagesFromItemDescription
{
  if (self.itemDescription) {
    return [self imagesFromHTML:self.itemDescription];
  }
  
  return nil;
}

- (NSArray *)imagesFromContent
{
  if (self.content) {
    return [self imagesFromHTML:self.content];
  }
  
  return nil;
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
    _itemDescription = [aDecoder decodeObjectForKey:@"itemDescription"];
    _content = [aDecoder decodeObjectForKey:@"content"];
    _link = [aDecoder decodeObjectForKey:@"link"];
    _commentsLink = [aDecoder decodeObjectForKey:@"commentsLink"];
    _commentsFeed = [aDecoder decodeObjectForKey:@"commentsFeed"];
    _commentsCount = [aDecoder decodeObjectForKey:@"commentsCount"];
    _pubDate = [aDecoder decodeObjectForKey:@"pubDate"];
    _author = [aDecoder decodeObjectForKey:@"author"];
    _guid = [aDecoder decodeObjectForKey:@"guid"];
    
    _mediaTitle = [aDecoder decodeObjectForKey:@"mediaTitle"];
    _mediaDescription = [aDecoder decodeObjectForKey:@"mediaDescription"];
    _mediaCredits = [aDecoder decodeObjectForKey:@"mediaCredits"];
    _mediaThumbnails = [aDecoder decodeObjectForKey:@"mediaThumbnails"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.title forKey:@"title"];
  [aCoder encodeObject:self.itemDescription forKey:@"itemDescription"];
  [aCoder encodeObject:self.content forKey:@"content"];
  [aCoder encodeObject:self.link forKey:@"link"];
  [aCoder encodeObject:self.commentsLink forKey:@"commentsLink"];
  [aCoder encodeObject:self.commentsFeed forKey:@"commentsFeed"];
  [aCoder encodeObject:self.commentsCount forKey:@"commentsCount"];
  [aCoder encodeObject:self.pubDate forKey:@"pubDate"];
  [aCoder encodeObject:self.author forKey:@"author"];
  [aCoder encodeObject:self.guid forKey:@"guid"];
  
  [aCoder encodeObject:self.mediaTitle forKey:@"mediaTitle"];
  [aCoder encodeObject:self.mediaDescription forKey:@"mediaDescription"];
  [aCoder encodeObject:self.mediaCredits forKey:@"mediaCredits"];
  [aCoder encodeObject:self.mediaThumbnails forKey:@"mediaThumbnails"];
}

#pragma mark - NSObject Protocol

- (BOOL)isEqual:(RSSItem *)object
{
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }
  return [self.link.absoluteString isEqualToString:object.link.absoluteString];
}

- (NSUInteger)hash
{
  return [self.link hash];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<%@: %@>", [self class],
          [self.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

@end
