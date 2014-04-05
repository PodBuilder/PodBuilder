//
//  NSDictionary+Map.h
//  PodBuilder
//
//  Created by William Kent on 4/5/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Map)

- (NSArray *)arrayByTranslatingKeyValuePairsWithBlock:(id (^)(id key, id value))block;

@end
