//
//  MailMessageMoverAppDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 02/09/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "MailMessageMoverAppDelegate.h"
#import "MailEngine.h"

@implementation MailMessageMoverAppDelegate

@synthesize window, inputField, tfDelegate;

MailEngine *myEngine;


- (IBAction) quitApplication:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //NSLog(@"app launched");
    
    myEngine = [MailEngine sharedInstance];
    
    NSString *path = [myEngine saveFilePath];
    BOOL fileExists= [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (fileExists) {
        
        NSData* data = [NSData dataWithContentsOfFile:path];
        NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        //NSLog(@"output of myArray: %@", myArray);
        if ([myArray count] != 0) {
            //NSLog(@"Need to deal with loaded text");
            NSString *savedName;
            for (NSInteger i = 0; i < [myArray count]; ++i) {
                savedName = [myArray objectAtIndex:i];
                //NSLog(@"item at index %lu is %@", i, savedName);
            }
            
            [inputField setStringValue:savedName];
            [tfDelegate changeFocusToView];
            
        } else {
            //NSLog(@"File exists at %@, but it's empty", path);
        }
    } else {
        
        //NSLog(@"File does not exist at %@", path);
        NSString *content = @"";
        NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
        [[NSFileManager defaultManager] createFileAtPath:path contents:fileContents attributes:nil];
        
        //        window.window
    }

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"app terminating");
}

@end
