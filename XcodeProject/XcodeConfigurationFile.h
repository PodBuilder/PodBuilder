//
//  XcodeConfigurationFile.h
//  PodBuilder
//
//  Created by William Kent on 4/5/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XcodeConfigurationFile : NSObject

/// Creates an instance of \c XcodeConfigurationFile containing no settings.
/// \remarks This is a designated initializer.
- (id)init;
/// Creates an instance of \c XcodeConfigurationFile containing settings obtained from parsing the given string.
/// \remarks This is a designated initializer.
- (id)initWithConfigurationFileContents:(NSString *)sourceCode;
/// Creates an instance of \c XcodeConfigurationFile containing settings obtained from reading from the given stream.
- (id)initByParsingData:(NSData *)data;
/// Creates an instance of \c XcodeConfigurationFile containing settings obtained from reading from the given URL.
- (id)initByReadingURL:(NSURL *)location;

#pragma mark Properties

@property (readonly) NSMutableDictionary *attributes;
@property (readonly) NSMutableSet *frameworks;
@property (readonly) NSMutableSet *weakLinkedFrameworks;
@property (readonly) NSMutableSet *otherLibraries;
@property (readonly) NSMutableArray *includedFiles;

@end
