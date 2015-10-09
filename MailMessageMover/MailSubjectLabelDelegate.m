//
//  MailSubjectLabelDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "MailSubjectLabelDelegate.h"

@implementation MailSubjectLabelDelegate

@synthesize lbStatus, errorLabel, moveButton;

//on app start up, run this to check what emails are selected
- (void) awakeFromNib {

    //NSLog(@"in awake from nib in MailSubjectLabelDelegate");
    
    NSString *message = [self updateMessageInfo];
    //NSLog(@"updating label with message: %@", message);
    //Update the label value to the AppleScript response
    [lbStatus setStringValue:message];
    
    //Look for text in message
    NSRange range = [message rangeOfString:@"No message selected" options:NSCaseInsensitiveSearch];
    //NSLog(@"rnage location: %lu", range.location);
    
    //if "No message selected" then set error and disable button
    if (range.location != NSNotFound) {
        [errorLabel setStringValue:@"No messages selected, moving not an option."];
        [moveButton setEnabled:false];
    }
    
}

//Calls an AppleScript to get the required details
- (NSString *) updateMessageInfo {
    //NSLog(@"In updateMessageInfo");
    
    //Get the path of the AppleScript to run
    NSString *path = [[NSBundle mainBundle] pathForResource:@"getMailMessageInfo" ofType:@"scpt"];
    
    //Load the AppleScript
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    if (script != nil) {
        //Run the AppleScript and get a result
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSString *scriptReturn = [result stringValue];
        //NSLog(@"updateMessageInfo script return: %@",scriptReturn);
        
        if (scriptReturn == nil)
            return @"N/A";
        else
            return scriptReturn;
    } else {
        return @"N/A";
    }
}

- (void) controlTextDidChange :(NSNotification *) sender {}

- (void) changeFocusToView {}

@end
