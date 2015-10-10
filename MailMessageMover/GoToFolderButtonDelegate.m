//
//  TestButtonDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "GoToFolderButtonDelegate.h"
#import "OutlineViewController.h"
#import "Mailbox.h"
#import "ButtonUtil.h"

@implementation GoToFolderButtonDelegate

@synthesize outlineView, goToFolderButton;

-(BOOL) checkIfItemSelected : (Mailbox*) item {
    if (item == NULL) {
        return false;
    } else {
        return true;
    }
}

- (IBAction) goToFolderButtonClicked:(id)sender {
    //NSLog(@"go to folder button clicked");
    
    Mailbox *selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    //NSLog(@"Selected item in outline view is: %@", selectedItem.name);
    
    BOOL *selected = [ButtonUtil checkIfItemSelected:selectedItem];
    
    if (selected) {
        
        NSRange match = [selectedItem.fullPath rangeOfString: @"/"];
        NSString* pathWithoutAccount = [selectedItem.fullPath substringFromIndex:match.location + 1];
        //NSLog(@"mailbox: %@ and account: %@", selectedItem.fullPath, selectedItem.accountString);
        NSString* scriptTemplate = [NSString stringWithFormat:@" \
    tell application \"Mail\" \n \
    \n \
    set boxToGoTo to get the mailbox \"%@\" of account \"%@\" \n \
    set selected mailboxes of the front message viewer to boxToGoTo \n \
    activate \n \
    \n \
    end tell", pathWithoutAccount, selectedItem.accountString];
        //NSLog(@"Calling script as follows: %@", scriptTemplate);
    
        NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
        if (script != nil) {
            NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
            //NSLog(@"result = %@", result.stringValue);
        }
        
        [ButtonUtil writeArray:selectedItem];
        [ButtonUtil focusMailAndQuit];
        
    }

}

@end
