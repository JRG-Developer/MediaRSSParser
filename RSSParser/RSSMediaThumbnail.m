//
//  RSSMediaThumbnail.m
//  Pods
//
//  Created by Joshua on 4/2/14.
//
//

#import "RSSMediaThumbnail.h"

@implementation RSSMediaThumbnail

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {        
        _url = [aDecoder decodeObjectForKey:@"url"];
        _height = [[aDecoder decodeObjectForKey:@"height"] floatValue];
        _width = [[aDecoder decodeObjectForKey:@"width"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:@(self.height) forKey:@"height"];
    [aCoder encodeObject:@(self.width) forKey:@"width"];
}

@end
