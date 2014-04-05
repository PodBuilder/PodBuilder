//
//  NSArray+Map.h
//  PodBuilder
//
//  Created by William Kent on 4/5/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)arrayByTranslatingValues:(id (^)(id oldValue))block;

@end
