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
    
    NSLog(@"in write Array: %@", myArray);
        
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    NSString *path = [myEngine saveFilePath];
    
    NSLog(@"Path is %@", path);
    [data writeToFile:path atomically:YES error:nil];
    
    [myArray release];
}

+ (BOOL) checkIfItemSelected : (Mailbox*) item {
    //NSLog(@"in check if item selected");
    if (item == NULL) {
        return false;
    } else {
        return true;
    }
}

+ (void) focusMailAndQuit {
    
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

-(ButtonUtil *) init {
    if (!myEngine) {
        myEngine = [MailEngine sharedInstance];
    }
    
    return self;
}

@end
