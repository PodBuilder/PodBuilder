//
//  PodDocument.m
//  PodBuilder
//
//  Created by William Kent on 4/4/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "PodDocument.h"
#import "PodDocumentWindowController.h"

@implementation PodDocument

- (id)init {
    self = [super init];
    
    if (self) {
        // Add your subclass-specific initialization here.
    }
    
    return self;
}

- (void)makeWindowControllers {
    PodDocumentWindowController *windowController = [[PodDocumentWindowController alloc] init];
    [self addWindowController:windowController];
    [self setWindow:windowController.window];
}

#pragma mark Saving & Loading

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to a file wrapper of the specified type.
    // If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    if (outError != NULL) *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    return nil;
}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from a file wrapper of the specified type.
    // If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    if (outError != NULL) *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:nil];
    return NO;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

+ (BOOL)preservesVersions {
    // Disable OS X Versions, as it conflicts with Git.
    return NO;
}

@end
