//
//  RSSMediaContent.h
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

#import <CoreGraphics/CoreGraphics.h>

/**
 *  `RSSMediaContent` corresponds to a single `media:content` element within an `item` element.
 */
@interface RSSMediaContent : NSObject <NSCoding>

/**
 *  This property corresponds to the `url` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it "should specify the direct URL to the media object."
 */
@property (nonatomic, copy) NSURL *url;

/**
 *  This property corresponds to the `fileSize` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "number of bytes of the media object."
 */
@property (nonatomic, assign) NSInteger fileSize;

/**
 *  This property corresponds to the `type` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "standard MIME type of the object."
 */
@property (nonatomic, copy) NSString *type;

/**
 *  This property corresponds to the `medium` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "type of object (image | audio | video | document | executable). While this attribute can at times seem redundant if type is supplied, it is included because it simplifies decision making on the reader side, as well as flushes out any ambiguities between MIME type and object type."
 */
@property (nonatomic, copy) NSString *medium;

/**
 *  This property corresponds to the `isDefault` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it "determines if this is the default object that should be used [of all the `RSSMediaContent` objects]".
 */
@property (nonatomic, assign) BOOL isDefault;

/**
 *  This property corresponds to the `expression` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it "determines if the object is a sample or the full version of the object, or even if it is a continuous stream (sample | full | nonstop). Default value is "full"."
 */
@property (nonatomic, copy) NSString *expression;

/**
 *  This property corresponds to the `bitrate` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "kilobits per second rate of media."
 */
@property (nonatomic, assign) NSInteger bitrate;

/**
 *  This property corresponds to the `framerate` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "number of frames per second for the media object."
 */
@property (nonatomic, assign) NSInteger framerate;

/**
 *  This property corresponds to the `samplingRate` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "number of samples per second taken to create the media object."
 */
@property (nonatomic, assign) CGFloat samplingRate;

/**
 *  This property corresponds to the `channels` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "number of audio channels in the media object."
 */
@property (nonatomic, assign) NSInteger channels;

/**
 *  This property corresponds to the `duration` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "number of seconds the media object plays."
 */
@property (nonatomic, assign) NSInteger duration;

/**
 *  The `size.height` corresponds to the `height` attribrute, and the `size.width` corresponds to the `width` attribute on a `media:content` element.
 *
 *  Per the Media RSS specificiation, "height is the height of the media object," and "width is the width of the width object."
 *  
 *  Units are expected to be in pixels.
 */
@property (nonatomic, assign) CGSize size;

/**
 *  This property corresponds to the `lang` attribute on a `media:content` element.
 *
 *  Per the Media RSS specification, it is the "primary language encapsulated in the media object. Language codes possible are detailed in RFC 3066. This attribute is used similar to the `xml:lang attribute` detailed in the XML 1.0 Specification (Third Edition)"
 */
@property (nonatomic, copy) NSString *language;

@end
