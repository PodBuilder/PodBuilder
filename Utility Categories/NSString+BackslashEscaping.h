//
//  NSString+BackslashEscaping.h
//  PodBuilder
//
//  Created by William Kent on 5/10/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BackslashEscaping)

// Note that these methods neither escape or unescape ASCII NUL (`\0`).
- (NSString *)unescapedString;
- (NSString *)escapedString;

@end
