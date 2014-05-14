//
//  NSString+NSRepeatedString.h
//  PodBuilder
//
//  Created by William Kent on 5/14/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSRepeatedString)

+ (NSString *)stringWithString:(NSString *)base repeatedTimes:(NSUInteger)count;

@end
