//
//  RSSMediaThumbnail.h
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

#import <CoreGraphics/CoreGraphics.h>

/**
 *  `RSSMediaThumbnail` corresponds to a single `media:thumbnail` element within an `item` element.
 */
@interface RSSMediaThumbnail : NSObject <NSCoding>

/**
 *  This property corresponds to the `url` attribute on a `media:thumbnail` element.
 */
@property (nonatomic, copy) NSURL *url;

/**
 *  The `size.height` corresponds to the `height` attribrute, and the `size.width` corresponds to the `width` attribute on a `media:thumbnail` element.
 */
@property (nonatomic) CGSize size;

/**
 *  This property corresponds to the `time` attribute on a `media:thumbnail` element.
 *
 *  Per the Media RSS specification, it "specifies the time offset in relation to the media object. Typically this is used when creating multiple keyframes within a single video. The format for this attribute should be in the DSM-CC's Normal Play Time (NTP) as used in RTSP [RFC 2326 3.6 Normal Play Time]"
 *
 *  The expected format (in NTP) is `H:M:S.h` or simply `S.h`, where `H` is hours, `M` is minutes, `S` is seconds and `h` is fractions of a second.
 */
@property (nonatomic, copy) NSString *timeOffset;

@end
