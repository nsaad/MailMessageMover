//
//  TestButtonDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "CancelButtonDelegate.h"

@implementation CancelButtonDelegate

@synthesize cancelButton;

-(void) focusMailAndQuit {
    
    NSString *scriptTemplate = @"Tell application \"Mail\" \
    activate \
    end tell";
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        //NSLog(@"result = %@", result);
    }
    
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction) cancelButtonClicked:(id) sender {
    [self focusMailAndQuit];
}

@end
