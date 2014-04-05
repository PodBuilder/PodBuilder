//
//  NSDictionary+Map.m
//  PodBuilder
//
//  Created by William Kent on 4/5/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "NSDictionary+Map.h"

@implementation NSDictionary (Map)

- (NSArray *)arrayByTranslatingKeyValuePairsWithBlock:(id (^)(id key, id value))block {
    NSAssert(block != NULL, @"Block must not be NULL");
    
    NSMutableArray *retval = [NSMutableArray array];
    for (NSString *key in self.allKeys) {
        [retval addObject:block(key, self[key])];
    }
    
    return retval;
}

@end
