//
//  NSString+BackslashEscaping.m
//  PodBuilder
//
//  Created by William Kent on 5/10/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "NSString+BackslashEscaping.h"

@implementation NSString (BackslashEscaping)

- (NSString *)unescapedString {
    NSMutableString *retval = [self mutableCopy];
    
    [retval replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\\\"" withString:@"\"" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\\r" withString:@"\r" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\\n" withString:@"\n" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\\t" withString:@"\t" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\\v" withString:@"\v" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\\f" withString:@"\f" options:0 range:NSMakeRange(0, retval.length)];
    
    return retval;
}

- (NSString *)escapedString {
    NSMutableString *retval = [self mutableCopy];
    
    [retval replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\r" withString:@"\\r" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\n" withString:@"\\n" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\t" withString:@"\\t" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\v" withString:@"\\v" options:0 range:NSMakeRange(0, retval.length)];
    [retval replaceOccurrencesOfString:@"\f" withString:@"\\f" options:0 range:NSMakeRange(0, retval.length)];
    
    return retval;
}

@end
