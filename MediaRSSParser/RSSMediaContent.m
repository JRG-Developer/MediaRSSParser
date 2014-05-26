//
//  RSSMediaContent.m
//  RSSParser
//
//  Created by Joshua Greene on 4/2/14.
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

#import "RSSMediaContent.h"

@implementation RSSMediaContent

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super init]) {
    _url = [aDecoder decodeObjectForKey:@"url"];
    _fileSize = [[aDecoder decodeObjectForKey:@"fileSize"] intValue];
    _type = [aDecoder decodeObjectForKey:@"type"];
    _medium = [aDecoder decodeObjectForKey:@"medium"];
    _isDefault = [[aDecoder decodeObjectForKey:@"isDefault"] boolValue];
    _expression = [aDecoder decodeObjectForKey:@"expression"];
    _bitrate = [[aDecoder decodeObjectForKey:@"bitrate"] intValue];
    _framerate = [[aDecoder decodeObjectForKey:@"framerate"] intValue];
    _samplingRate = [[aDecoder decodeObjectForKey:@"samplingRate"] floatValue];
    _channels = [[aDecoder decodeObjectForKey:@"channels"] intValue];
    _duration = [[aDecoder decodeObjectForKey:@"duration"] intValue];
    _size.height = [[aDecoder decodeObjectForKey:@"height"] floatValue];
    _size.width = [[aDecoder decodeObjectForKey:@"width"] floatValue];
    _language = [aDecoder decodeObjectForKey:@"language"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.url forKey:@"url"];
  [aCoder encodeObject:@(self.fileSize) forKey:@"fileSize"];
  [aCoder encodeObject:self.type forKey:@"type"];
  [aCoder encodeObject:self.medium forKey:@"medium"];
  [aCoder encodeObject:@(self.isDefault) forKey:@"isDefault"];
  [aCoder encodeObject:self.expression forKey:@"expression"];
  [aCoder encodeObject:@(self.bitrate) forKey:@"bitrate"];
  [aCoder encodeObject:@(self.framerate) forKey:@"framerate"];
  [aCoder encodeObject:@(self.samplingRate) forKey:@"samplingRate"];
  [aCoder encodeObject:@(self.channels) forKey:@"channels"];
  [aCoder encodeObject:@(self.duration) forKey:@"duration"];
  [aCoder encodeObject:@(self.size.height) forKey:@"height"];
  [aCoder encodeObject:@(self.size.width) forKey:@"width"];
  [aCoder encodeObject:self.language forKey:@"language"];
}

@end
