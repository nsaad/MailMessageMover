//
//  TestButtonDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "TestButtonDelegate.h"
#import "OutlineViewController.h"
#import "MailEngine.h"
#import "Mailbox.h"

@implementation TestButtonDelegate

@synthesize outlineView, lbStatus, moveMessageButton, goToFolderButton;
MailEngine *myEngine;

- (IBAction)moveMessageButtonClicked:(id)sender {
    NSLog(@"move message button clicked");
    
    Mailbox *selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    NSLog(@"Selected item in outline view is: %@", selectedItem.name);
    
    NSString* scriptTemplate = [NSString stringWithFormat:@" \
    tell application \"Mail\" \n \
	set theMessages to the selected messages of message viewer 1 \n \
	\n \
	repeat with aMessage in theMessages \n \
    set mailbox of aMessage to mailbox \"%@\" of account \"%@\" \n \
	end repeat \n \
    end tell", selectedItem.fullPath, selectedItem.accountString];
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSLog(@"result = %@", result);
    }
    
    script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSLog(@"result = %@", result);
    }
    
    [[NSApplication sharedApplication] terminate:nil];

}

- (IBAction)goToFolderButtonClicked:(id)sender {
    NSLog(@"go to folder button clicked");
    
    Mailbox *selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    NSLog(@"Selected item in outline view is: %@", selectedItem.name);
    
    NSString* scriptTemplate = [NSString stringWithFormat:@" \
    tell application \"Mail\" \n \
    \n \
    set boxToGoTo to get the mailbox \"%@\" of account \"%@\" \n \
    set selected mailboxes of the front message viewer to boxToGoTo \n \
    \n \
    end tell", selectedItem.fullPath, selectedItem.accountString];
    NSLog(@"Calling script as follows: %@", scriptTemplate);
    
    //NSString* actualScript = [NSString stringWithFormat:scriptTemplate, selectedItem.name, selectedItem.accountString];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSLog(@"result = %@", result);
    }
    
    myEngine = [MailEngine sharedInstance];
    //NSString *message = [myEngine updateMessageInfo];
    //[lbStatus setStringValue:message];
    
    scriptTemplate = @"Tell application \"Mail\" \
        activate \
    end tell";
    
    script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSLog(@"result = %@", result);
    }
    
    [[NSApplication sharedApplication] terminate:nil];

}

@end
