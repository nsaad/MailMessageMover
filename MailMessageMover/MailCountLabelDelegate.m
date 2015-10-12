//
//  MailCountLabelDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "MailCountLabelDelegate.h"

@implementation MailCountLabelDelegate

@synthesize lbMessageCount;

//on app start up, run this to check how many emails are selected
- (void) awakeFromNib {

    //NSLog(@"in awake from nib in MailCountLabelDelegate");
    
    NSString *messageCount = [self updateMessageCount];
    
    if ([messageCount length] != 0) {
        //NSLog(@"strcmp(messageCount, 1): %d", [messageCount isEqualToString:@"1"]);
        if ([messageCount isEqualToString:@"1"]) {
            messageCount = [messageCount stringByAppendingString:@" email"];
        } else {
            messageCount = [messageCount stringByAppendingString:@" emails"];
        }
        [lbMessageCount setStringValue:messageCount];
    } else {
        [lbMessageCount setStringValue:@""];
    }
}

//Calls an AppleScript to get the required details
- (NSString *) updateMessageCount {
    
    //Get the path of the AppleScript to run
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countSelectedMessages" ofType:@"scpt"];
    
    //Load the AppleScript
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    if (script != nil) {
        //Run the AppleScript and get a result
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSString *scriptReturn = [result stringValue];
        //NSLog(@"Counted messages: %@",scriptReturn);
        
        if (scriptReturn == nil)
            return @"N/A";
        else
            return scriptReturn;
    } else {
        return @"N/A";
    }
}

@end
