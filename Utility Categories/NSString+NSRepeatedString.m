//
//  NSString+NSRepeatedString.m
//  PodBuilder
//
//  Created by William Kent on 5/14/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "NSString+NSRepeatedString.h"

@implementation NSString (NSRepeatedString)

+ (NSString *)stringWithString:(NSString *)base repeatedTimes:(NSUInteger)count {
    if (count == 0) return @"";
    
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        [cache setCountLimit:50];
    });
    
    NSString *cacheKey = [NSString stringWithFormat:@"%lu@%@", (unsigned long)count, base];
    NSString *cacheValue = [cache objectForKey:cacheKey];
    if (cacheValue != nil) return cacheValue;
    
    NSMutableString *repeated = [NSMutableString string];
    for (NSUInteger i = 0; i < count; i++) [repeated appendString:base];
    cacheValue = repeated;
    [cache setObject:cacheValue forKey:cacheKey];
    
    return cacheValue;
}

@end
