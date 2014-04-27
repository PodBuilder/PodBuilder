/*
 * Copyright (c) 2012 Eloy Durán <eloy.de.enige@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "XcodeConfiguration.h"
#import "NSDictionary+MapFoldReduce.h"
#import "NSArray+MapFoldReduce.h"
#import "NSString+ShellSplit.h"

@implementation XcodeConfiguration

- (id)init {
    self = [super init];
    
    if (self) {
        _attributes = [[NSMutableDictionary alloc] init];
        _includedFiles = [[NSMutableArray alloc] init];
        _frameworks = [[NSMutableSet alloc] init];
        _weakLinkedFrameworks = [[NSMutableSet alloc] init];
        _otherLibraries = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (id)initWithConfigurationFileContents:(NSString *)sourceCode {
    self = [self init];
    
    if (self) {
        NSArray *lines = [sourceCode componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        for (NSString *rawLine in lines) {
            NSString *line = [self stripCommentFromConfigurationFileLine:rawLine];
            
            NSString *includePath;
            BOOL isInclude = [self extractIncludeFileTarget:&includePath fromConfigurationFileLine:line];
            if (isInclude) {
                [self.includedFiles addObject:includePath];
            } else {
                NSString *key;
                NSString *value;
                BOOL isRegularLine = [self extractKey:&key andValue:&value fromConfigurationFileLine:line];
                
                if (isRegularLine) {
                    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    self.attributes[key] = value;
                }
            }
        }
    }
    
    return self;
}

- (id)initByParsingData:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self initWithConfigurationFileContents:string];
}

- (id)initByReadingURL:(NSURL *)location {
    return [self initByParsingData:[NSData dataWithContentsOfURL:location]];
}

- (id)initWithConfigurationDictionary:(NSDictionary *)settings {
    self = [self init];
    
    NSString *flagString = settings[@"OTHER_LDFLAGS"] ?: @"";
    flagString = [[flagString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    
    NSArray *flags = [flagString componentsSplitUsingShellQuotingRules];
    NSMutableArray *fixedFlags = [NSMutableArray array];
    
    NSInteger count = flags.count;
    for (NSInteger i = 0; i < count; i++) {
        NSString *flag = flags[i];
        
        if ([flag hasPrefix:@"-l"]) {
            [self.otherLibraries addObject:[flag substringFromIndex:2]];
        } else if ([flag hasPrefix:@"-framework"]) {
            NSInteger offset = [@"-framework" length] + 1;
            [self.frameworks addObject:[flag substringFromIndex:offset]];
        } else if ([flag hasPrefix:@"-weak_framework"]) {
            NSInteger offset = [@"-weak_framework" length] + 1;
            [self.weakLinkedFrameworks addObject:[flag substringFromIndex:offset]];
        } else {
            NSRange range = [flag rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (!(range.location == NSNotFound && range.length == 0)) {
                [fixedFlags addObject:[NSString stringWithFormat:@"\"%@\"", flag]];
            } else {
                [fixedFlags addObject:flag];
            }
        }
    }
    
    _attributes = [settings mutableCopy];
    if (fixedFlags.count != 0) self.attributes[@"OTHER_LDFLAGS"] = [fixedFlags componentsJoinedByString:@" "];
    else [self.attributes removeObjectForKey:@"OTHER_LDFLAGS"];
    
    return self;
}

#pragma mark Properties

- (NSDictionary *)configurationDictionary {
    NSMutableDictionary *settings = [self.attributes copy];
    NSMutableString *flags = settings[@"OTHER_LDFLAGS"] ?: @"";
    flags = [[flags stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    
    [flags appendString:[self.otherLibraries.allObjects reduceWithInitialValue:[NSMutableString string] block:^(id reduced, id value) {
        [reduced appendFormat:@" -l%@", value];
    }]];
    
    [flags appendString:[self.frameworks.allObjects reduceWithInitialValue:[NSMutableString string] block:^(id reduced, id value) {
        [reduced appendFormat:@" -framework %@", value];
    }]];
    
    [flags appendString:[self.weakLinkedFrameworks.allObjects reduceWithInitialValue:[NSMutableString string] block:^(id reduced, id value) {
        [reduced appendFormat:@" -weak_framework %@", value];
    }]];
    
    NSString *finalFlags = [flags stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (finalFlags.length != 0) settings[@"OTHER_LDFLAGS"] = finalFlags;
    else [settings removeObjectForKey:@"OTHER_LDFLAGS"];
    
    return settings;
}

- (NSString *)configurationFileSource {
    NSArray *includeLines = [self.includedFiles arrayByTranslatingValues:^id(id oldValue) {
        NSString *pathWithExtension = oldValue;
        if (![pathWithExtension.pathExtension isEqualToString:@"xcconfig"])
            pathWithExtension = [NSString stringWithFormat:@"%@.xcconfig", pathWithExtension];

        return [NSString stringWithFormat:@"#include \"%@\"", pathWithExtension];
    }];
    
    NSArray *settingLines = [[self configurationDictionary] arrayByTranslatingKeyValuePairsWithBlock:^id(id key, id value) {
        return [NSString stringWithFormat:@"%@ = %@", key, value];
    }];
    
    // Write out the #include lines, a blank line (for aesthetic purposes), and then the setting lines.
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObjectsFromArray:includeLines];
    [lines addObject:@""];
    [lines addObjectsFromArray:settingLines];
    
    return [lines componentsJoinedByString:@"\n"];
}

- (void)mergeConfiguration:(XcodeConfiguration *)other {
    for (NSString *key in other.attributes.allKeys) {
        NSString *oldValue = [self.attributes[key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *newValue = [other.attributes[key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSArray *existing = [oldValue componentsSplitUsingShellQuotingRules];
        if ([existing containsObject:newValue]) self.attributes[key] = oldValue;
        else self.attributes[key] = [NSString stringWithFormat:@"%@ %@", oldValue, newValue];
    }
    
    [self.frameworks addObjectsFromArray:other.frameworks.allObjects];
    [self.weakLinkedFrameworks addObjectsFromArray:other.weakLinkedFrameworks.allObjects];
    [self.otherLibraries addObjectsFromArray:other.otherLibraries.allObjects];
}

#pragma mark Private Methods

- (NSString *)stripCommentFromConfigurationFileLine:(NSString *)line {
    static NSRegularExpression *commentRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commentRegex = [NSRegularExpression regularExpressionWithPattern:@"//.*$" options:NSRegularExpressionAnchorsMatchLines error:NULL];
        NSAssert(commentRegex != nil, @"Could not compile regular expression");
    });
    
    return [commentRegex stringByReplacingMatchesInString:line options:0 range:NSMakeRange(0, line.length) withTemplate:@""];
}

- (BOOL)extractIncludeFileTarget:(NSString **)path fromConfigurationFileLine:(NSString *)line {
    static NSRegularExpression *includeRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        includeRegex = [NSRegularExpression regularExpressionWithPattern:@"#include\\s*\"(.+)\"" options:0 error:NULL];
        NSAssert(includeRegex != nil, @"Could not compile regular expression");
    });
    
    NSTextCheckingResult *match = [includeRegex firstMatchInString:line options:0 range:NSMakeRange(0, line.length)];
    
    NSRange range = [match rangeAtIndex:1];
    if (range.location == NSNotFound && range.length == 0) return NO;
    if (path != NULL) *path = [line substringWithRange:range];
    return YES;
}

- (BOOL)extractKey:(NSString **)key andValue:(NSString **)value fromConfigurationFileLine:(NSString *)line {
    static NSRegularExpression *lineRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineRegex = [NSRegularExpression regularExpressionWithPattern:@"(.+?)\\s*=\\s*(.+)" options:0 error:NULL];
        NSAssert(lineRegex != nil, @"Could not compile regular expression");
    });
    
    NSTextCheckingResult *match = [lineRegex firstMatchInString:line options:0 range:NSMakeRange(0, line.length)];
    
    NSRange range = [match rangeAtIndex:1];
    if (range.location == NSNotFound && range.length == 0) return NO;
    if (key != NULL) *key = [line substringWithRange:range];
    
    range = [match rangeAtIndex:2];
    if (range.location == NSNotFound && range.length == 0) return NO;
    if (value != NULL) *value = [line substringWithRange:range];
    
    return YES;
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initWithConfigurationDictionary:[self.configurationDictionary copy]];
}

#pragma mark NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p: %@>", NSStringFromClass([self class]), self, self.configurationDictionary];
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    XcodeConfiguration *other = object;
    return ([self.attributes isEqual:other.attributes] &&
            [self.frameworks isEqual:other.frameworks] &&
            [self.weakLinkedFrameworks isEqual:other.frameworks] &&
            [self.otherLibraries isEqual:other.otherLibraries]);
}

- (NSUInteger)hash {
    return self.attributes.hash ^ self.frameworks.hash ^ self.weakLinkedFrameworks.hash ^ self.otherLibraries.hash;
}

@end