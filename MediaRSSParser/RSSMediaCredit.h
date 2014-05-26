//
//  RSSMediaCredit.h
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

#import <Foundation/Foundation.h>

/**
 *  `RSSMediaCredit` corresponds to a single `media:credit` element within an `item` or `entry` element.
 */
@interface RSSMediaCredit : NSObject <NSCoding>

/**
 *  This property corresponds to `role` attribute on the `media:credit` element.
 *
 *  Per the Media RSS specification, it "specifies the role the entity played."
 */
@property (nonatomic, copy) NSString *role;

/**
 *  This property corresponds to the value of the `media:credit` element.
 */
@property (nonatomic, copy) NSString *value;
@end
