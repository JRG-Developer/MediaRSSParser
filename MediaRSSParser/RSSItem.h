//
//  RSSItem.h
//  RSSParser
//
//  Modified by Joshua Greene on 4/2/14 (added basic support for Media RSS).
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

#import <UIKit/UIKit.h>

@interface RSSItem : NSObject <NSCoding>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSURL *link;
@property (nonatomic, copy) NSURL *commentsLink;
@property (nonatomic, copy) NSURL *commentsFeed;
@property (nonatomic, copy) NSNumber *commentsCount;
@property (nonatomic, copy) NSDate *pubDate;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *guid;

@property (nonatomic, copy) NSString *mediaTitle;
@property (nonatomic, copy) NSString *mediaDescription;
@property (nonatomic, copy) NSString *mediaText;
@property (nonatomic, copy) NSArray *mediaCredits;
@property (nonatomic, copy) NSArray *mediaThumbnails;
@property (nonatomic, copy) NSArray *mediaContent;

- (NSArray *)imagesFromItemDescription;
- (NSArray *)imagesFromContent;

@end
