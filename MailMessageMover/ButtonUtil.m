//
//  TestButtonDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "ButtonUtil.h"
#import "MailEngine.h"
#import "Mailbox.h"

@implementation ButtonUtil

MailEngine *myEngine;

+ (void) writeArray : (Mailbox *) selectedItem {
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    [myArray addObject:selectedItem.name];
    
    //NSLog(@"in write Array: %@", myArray);
        
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    NSString *path = [myEngine saveFilePath];
    
    //NSLog(@"Path is %@", path);
    [data writeToFile:path atomically:YES];
    
    [myArray release];
}

+ (BOOL) checkIfItemSelected : (Mailbox*) item {
    //NSLog(@"in check if item selected");
    if (item == NULL) {
        return NO;
    } else {
        return YES;
    }
}

+ (void) focusMailAndQuit {
    
    NSString *scriptTemplate = @"Tell application \"Mail\" \
    activate \
    end tell";
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
    if (script != nil) {
        [script executeAndReturnError:nil];
    }
    
    [[NSApplication sharedApplication] terminate:nil];
}

-(ButtonUtil *) init {
    if (!myEngine) {
        myEngine = [MailEngine sharedInstance];
    }
    
    return self;
}

@end
