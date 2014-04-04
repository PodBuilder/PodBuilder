//
//  PodDocumentWindowController.m
//  PodBuilder
//
//  Created by William Kent on 4/4/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "PodDocumentWindowController.h"

@implementation PodDocumentWindowController

- (id)init {
    return [self initWithWindowNibName:@"PodDocument"];
}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad {
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [super windowDidLoad];
}

@end
