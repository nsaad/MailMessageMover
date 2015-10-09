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

@synthesize outlineView, lbStatus, moveMessageButton, errorLabel;
MailEngine *myEngine;
BOOL isMoveButtonClicked;

- (IBAction)moveMessageButtonClicked:(id)sender {
    //NSLog(@"move message button clicked");
    
    Mailbox *selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    //NSLog(@"Selected item in outline view is: %@", selectedItem.name);
    
    BOOL *selected = [self checkIfItemSelected:selectedItem];
    
    if (selected) {
        [errorLabel setStringValue:@""];
        
        //On first click, with only one match, always move the message
        if (!isMoveButtonClicked && [myEngine countOfMatched] == 1) {
            NSLog(@"Only one item and it's selected, moving the message");
            [self moveTheMessage : selectedItem];
        //Otherwise, on first click, allow for the selection of the item when there's more then one match
        } else if (!isMoveButtonClicked) {
            NSLog(@"button was clicked for the first time now");
            isMoveButtonClicked = true;
        //When the button is clicked a second time, move the selected item
        } else {
            [self moveTheMessage:selectedItem];
        }
    } else {
        [errorLabel setStringValue:@"Please select a folder from the list"];
        NSLog(@"There's nothing selected, not progressing");
    }

}

- (void) moveTheMessage : (Mailbox *) selectedItem {
    NSLog(@"In moveTheMessage");
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
        //NSLog(@"result = %@", result);
    }
    
    [self writeArray:selectedItem];
    [self focusMailAndQuit];
}

-(void) writeArray : (Mailbox *) selectedItem {
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    [myArray addObject:selectedItem.name];
    
    NSLog(@"in write Array: %@", myArray);
        
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    NSString *path = [myEngine saveFilePath];
    
    NSLog(@"Path is %@", path);
    [data writeToFile:path atomically:YES error:nil];
    
    [myArray release];
}

-(BOOL) checkIfItemSelected : (Mailbox*) item {
    if (item == NULL) {
        return false;
    } else {
        return true;
    }
}

-(TestButtonDelegate *) init {
    if (!myEngine) {
        myEngine = [MailEngine sharedInstance];
        isMoveButtonClicked = false;
    }
    
    return self;
}

@end
