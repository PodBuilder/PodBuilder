//
//  NSArray+Map.m
//  PodBuilder
//
//  Created by William Kent on 4/5/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "NSArray+MapFoldReduce.h"

@implementation NSArray (MapFoldReduce)

- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id object))block {
    NSAssert(block != NULL, @"Block must not be NULL");
    
    NSInteger count = self.count;
    NSMutableArray *retval = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        id object = self[i];
        if (block(object)) [retval addObject:object];
    }
    
    return retval;
}

- (NSArray *)arrayWithObjectsNotPassingTest:(BOOL (^)(id object))block {
    NSAssert(block != NULL, @"Block must not be NULL");
    
    NSInteger count = self.count;
    NSMutableArray *retval = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        id object = self[i];
        if (!block(object)) [retval addObject:object];
    }
    
    return retval;
}

- (NSArray *)arrayByTranslatingValues:(id (^)(id oldValue))block {
    NSAssert(block != NULL, @"Block must not be NULL");
    
    NSInteger count = self.count;
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        retval[i] = block(self[i]);
    }
    
    return retval;
}

- (id)reduceWithInitialValue:(id)initialValue block:(void (^)(id reduced, id value))block {
    NSAssert(block != NULL, @"Block must not be NULL");
    
    id reduced = initialValue;
    NSInteger count = self.count;
    
    for (NSInteger i = 0; i < count; i++) {
        block(reduced, self[i]);
    }
    
    return reduced;
}

@end
