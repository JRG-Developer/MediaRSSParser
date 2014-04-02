//
//  RSSMediaCredit.m
//  Pods
//
//  Created by Joshua on 4/2/14.
//
//

#import "RSSMediaCredit.h"

@implementation RSSMediaCredit

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {        
        _role = [aDecoder decodeObjectForKey:@"role"];
        _value = [aDecoder decodeObjectForKey:@"value"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.role forKey:@"role"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

@end
