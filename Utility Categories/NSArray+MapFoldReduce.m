//
//  NSArray+Map.m
//  PodBuilder
//
//  Created by William Kent on 4/5/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "NSArray+MapFoldReduce.h"

@implementation NSArray (MapFoldReduce)

- (NSArray *)arrayByTranslatingValues:(id (^)(id oldValue))block {
    NSAssert(block != NULL, @"Block must not be NULL");
    
    NSInteger count = self.count;
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        retval[i] = block(self[i]);
    }
    
    return retval;
}

@end
