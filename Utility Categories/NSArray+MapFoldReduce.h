//
//  NSArray+Map.h
//  PodBuilder
//
//  Created by William Kent on 4/5/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MapFoldReduce)

- (NSArray *)arrayWithObjectsPassingTest:(BOOL (^)(id object))block;
- (NSArray *)arrayWithObjectsNotPassingTest:(BOOL (^)(id object))block;

- (NSArray *)arrayByTranslatingValues:(id (^)(id oldValue))block;
- (id)reduceWithInitialValue:(id)initialValue block:(void (^)(id reduced, id value))block;

@end
