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

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    NSLog(@"should teminate, called?");
    return YES;
}

//This doesn't work, it should be as follows, but that doesn't work either due to "Expected a type on UIApplication"
//- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//TODO: if I can figure this out, and have the call to [myEngine saveFilePath] happen here, it might happen later then the creation of the textfielddelegate

//The current issue is that the loading order varies and sometimes the text is loaded before the delegate is ready to observe the change event.

- (BOOL)willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"app did finish launching");
    
    return YES;
}

- (void) awakeFromNib {
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
                NSLog(@"item at index %lu is %@", i, savedName);
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
    }
}

@end
