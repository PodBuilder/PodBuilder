/*
 This method is based on shellwords.rb in Ruby 2.1.1
 Its license is reproduced below.
 
 Ruby is copyrighted free software by Yukihiro Matsumoto <matz@netlab.jp>.
 You can redistribute it and/or modify it under either the terms of the
 2-clause BSDL (see the file BSDL), or the conditions below:
 
 1. You may make and give away verbatim copies of the source form of the
 software without restriction, provided that you duplicate all of the
 original copyright notices and associated disclaimers.
 
 2. You may modify your copy of the software in any way, provided that
 you do at least ONE of the following:
 
 a) place your modifications in the Public Domain or otherwise
 make them Freely Available, such as by posting said
 modifications to Usenet or an equivalent medium, or by allowing
 the author to include your modifications in the software.
 
 b) use the modified software only within your corporation or
 organization.
 
 c) give non-standard binaries non-standard names, with
 instructions on where to get the original software distribution.
 
 d) make other distribution arrangements with the author.
 
 3. You may distribute the software in object code or binary form,
 provided that you do at least ONE of the following:
 
 a) distribute the binaries and library files of the software,
 together with instructions (in the manual page or equivalent)
 on where to get the original distribution.
 
 b) accompany the distribution with the machine-readable source of
 the software.
 
 c) give non-standard binaries non-standard names, with
 instructions on where to get the original software distribution.
 
 d) make other distribution arrangements with the author.
 
 4. You may modify and include the part of the software into any other
 software (possibly commercial).  But some files in the distribution
 are not written by the author, so that they are not under these terms.
 
 For the list of those files and their copying conditions, see the
 file LEGAL.
 
 5. The scripts and library files supplied as input to or produced as
 output from the software do not automatically fall under the
 copyright of the software, but belong to whomever generated them,
 and may be sold commercially, and may be aggregated with this
 software.
 
 6. THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE.
 */

#import "NSString+ShellSplit.h"

@implementation NSString (ShellSplit)

- (NSArray *)componentsSplitUsingShellQuotingRules {
    __block NSMutableArray *words = [NSMutableArray array];
    __block NSMutableString *field = [NSMutableString string];
    
    static NSRegularExpression *regex;
    static NSRegularExpression *escapeRemovalRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\G\\s*(?>([^\\s\\\\\\'\\\"]+)|'([^\\']*)'|\"((?:[^\\\"\\\\]|\\\\.?)|(\\S))(\\s|\\z)?" options:NSRegularExpressionAnchorsMatchLines error:NULL];
        escapeRemovalRegex = [NSRegularExpression regularExpressionWithPattern:@"\\(.)" options:0 error:NULL];
        NSAssert(regex != nil, @"Could not compile regex");
        NSAssert(escapeRemovalRegex != nil, @"Could not compile escape-removal regex");
    });
    
    [regex enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *word = [self substringWithRange:[result rangeAtIndex:1]];
        NSString *sq = [self substringWithRange:[result rangeAtIndex:2]];
        NSString *dq = [self substringWithRange:[result rangeAtIndex:3]];
        NSString *esc = [self substringWithRange:[result rangeAtIndex:4]];
        NSString *garbage = [self substringWithRange:[result rangeAtIndex:5]];
        NSString *sep = [self substringWithRange:[result rangeAtIndex:6]];
        
        if (garbage.length != 0) [NSException raise:NSInvalidArgumentException format:@"Unmatched quote in string %@", self];
        
        if (word != nil) {
            [field appendString:word];
        } else if (sq != nil) {
            [field appendString:sq];
        } else if (dq != nil) {
            [field appendString:[escapeRemovalRegex stringByReplacingMatchesInString:dq options:0 range:NSMakeRange(0, dq.length) withTemplate:@"$1"]];
        } else if (esc != nil) {
            [field appendString:[escapeRemovalRegex stringByReplacingMatchesInString:esc options:0 range:NSMakeRange(0, esc.length) withTemplate:@"$1"]];
        }
        
        if (sep.length != 0) {
            [words addObject:field];
            field = [NSMutableString string];
        }
    }];
    
    return words;
}

@end
