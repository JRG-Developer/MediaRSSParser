//
//  RSSChannel.m
//  MediaRSSParser
//
//  Created by Joshua Greene on 5/25/14.
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

#import "RSSChannel.h"

@implementation RSSChannel

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self) {
    _title = [aDecoder decodeObjectForKey:@"title"];
    _link = [aDecoder decodeObjectForKey:@"link"];
    _channelDescription = [aDecoder decodeObjectForKey:@"channelDescription"];
    
    _language = [aDecoder decodeObjectForKey:@"language"];
    _copyright = [aDecoder decodeObjectForKey:@"copyright"];
    _managingEditorEmail = [aDecoder decodeObjectForKey:@"managingEditorEmail"];
    _webMasterEmail = [aDecoder decodeObjectForKey:@"webMasterEmail"];
    _pubDate = [aDecoder decodeObjectForKey:@"pubDate"];
    _lastBuildDate = [aDecoder decodeObjectForKey:@"lastBuildDate"];
    _generator = [aDecoder decodeObjectForKey:@"generator"];
    _docsURL = [aDecoder decodeObjectForKey:@"docsURL"];
    _ttl = [[aDecoder decodeObjectForKey:@"ttl"] integerValue];
    _items = [aDecoder decodeObjectForKey:@"items"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.title forKey:@"title"];
  [aCoder encodeObject:self.link forKey:@"link"];
  [aCoder encodeObject:self.channelDescription forKey:@"channelDescription"];
  [aCoder encodeObject:self.language forKey:@"language"];
  [aCoder encodeObject:self.copyright forKey:@"copyright"];
  [aCoder encodeObject:self.managingEditorEmail forKey:@"managingEditorEmail"];
  [aCoder encodeObject:self.webMasterEmail forKey:@"webMasterEmail"];
  [aCoder encodeObject:self.pubDate forKey:@"pubDate"];
  [aCoder encodeObject:self.lastBuildDate forKey:@"lastBuildDate"];
  [aCoder encodeObject:self.generator forKey:@"generator"];
  [aCoder encodeObject:self.docsURL forKey:@"docsURL"];  
  [aCoder encodeObject:@(self.ttl) forKey:@"ttl"];
  [aCoder encodeObject:self.items forKey:@"items"];
}

@end
