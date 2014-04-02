//
//  RSSMediaThumbnail.h
//  Pods
//
//  Created by Joshua on 4/2/14.
//
//

#import <Foundation/Foundation.h>

@interface RSSMediaThumbnail : NSObject <NSCoding>
@property (strong,nonatomic) NSURL *url;
@property (assign,nonatomic) float height;
@property (assign,nonatomic) float width;
@end
