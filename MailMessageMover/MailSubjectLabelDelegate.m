//
//  MailSubjectLabelDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "MailSubjectLabelDelegate.h"
#import "MailEngine.h"

@implementation MailSubjectLabelDelegate

@synthesize lbStatus, errorLabel, moveButton;

- (void) awakeFromNib {
    //NSLog(@"in awake from nib in MailSubjectLabelDelegate");
    
    NSString *message = [self updateMessageInfo];
    //NSLog(@"updating label with message: %@", message);
    [lbStatus setStringValue:message];
    
    NSRange range = [message rangeOfString:@"No message selected" options:NSCaseInsensitiveSearch];
    //NSLog(@"rnage location: %lu", range.location);
    
    if (range.location != NSNotFound) {
        [errorLabel setStringValue:@"No messages selected, moving not an option."];
        [moveButton setEnabled:false];
    }
    
}

- (NSString *) updateMessageInfo {
    NSLog(@"In updateMessageInfo");
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"getMailMessageInfo" ofType:@"scpt"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSString *scriptReturn = [result stringValue];
        NSLog(@"updateMessageInfo script return: %@",scriptReturn);
        
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
