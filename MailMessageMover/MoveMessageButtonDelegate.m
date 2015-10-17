//
//  TestButtonDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "MoveMessageButtonDelegate.h"
#import "OutlineViewController.h"
#import "MailEngine.h"
#import "Mailbox.h"
#import "ButtonUtil.h"

@implementation MoveMessageButtonDelegate

@synthesize outlineView, errorLabel;

MailEngine *myEngine;
BOOL isMoveButtonClicked;

- (IBAction)moveMessageButtonClicked:(id)sender {
    //NSLog(@"move message button clicked");

    Mailbox *selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    //NSLog(@"Selected item in outline view is: %@", selectedItem.name);
    
    BOOL selected = [ButtonUtil checkIfItemSelected:selectedItem];
    
    if (selected) {
        [errorLabel setStringValue:@""];
        
        //On first click, with only one match, always move the message
        if (!isMoveButtonClicked && [myEngine countOfMatched] == 1) {
            //NSLog(@"Only one item and it's selected, moving the message");
            [self moveTheMessage : selectedItem];
        //Otherwise, on first click, allow for the selection of the item when there's more then one match
        } else if (!isMoveButtonClicked) {
            //NSLog(@"button was clicked for the first time now");
            isMoveButtonClicked = true;
        //When the button is clicked a second time, move the selected item
        } else {
            [self moveTheMessage:selectedItem];
        }
    } else {
        [errorLabel setStringValue:@"Please select a folder from the list"];
        //NSLog(@"There's nothing selected, not progressing");
    }

}

- (void) moveTheMessage : (Mailbox *) selectedItem {
    
    //Check where the first / is in the full path and select the path component without the account name
    NSRange match = [selectedItem.fullPath rangeOfString: @"/"];
    NSString* pathWithoutAccount = [selectedItem.fullPath substringFromIndex:match.location + 1];
    NSLog(@"in MoveTheMessage method - pWA: %@ - AS: %@", pathWithoutAccount, selectedItem.accountString);
    
    NSString* scriptTemplate = [NSString stringWithFormat:@" \
                                global destinationFolderName \n \
                                global destinationAccount \n \
                                global theMessageIDs \n \
                                 \n \
                                set destinationFolderName to \"%@\" \n \
                                set destinationAccount to \"%@\" \n \
                                 \n \
                                tell application \"Mail\" to try \n \
                                activate \n \
                                set theMessagesToMove to the selected messages of message viewer 1 \n \
                                 \n \
                                if (exists theMessagesToMove) then \n \
                                -- Get the details of the last selected message \n \
                                set firstMsg to last item of theMessagesToMove \n \
                                set theMailbox to firstMsg's mailbox \n \
                                 \n \
                                -- Get all the messages in the folder \n \
                                set theMessages to (every message of theMailbox) \n \
                                set theMessageIDs to (id of every message of theMailbox) \n \
                                set positionMessage to (my list_position(firstMsg, theMessages)) \n \
                                set countOfTotalMessages to (count of theMessages) \n \
                                 \n \
                                -- check how many messages are being moved \n \
                                if ((count of theMessagesToMove) is equal to (count of theMessages)) then \n \
                                --if all the messages, move the messages and deselect the message in the preview pane \n \
                                set moveDone to my do_move(theMessagesToMove) \n \
                                set selected messages of message viewer 1 to {} \n \
                                else if (positionMessage is equal to countOfTotalMessages) then \n \
                                         set moveDone to my do_move(theMessagesToMove) \n \
                                         set beforeLastMsg to ((count of theMessages) - 1) \n \
                                         set prevMsg to (item beforeLastMsg of theMessages) \n \
                                         set selected messages of message viewer 1 to {prevMsg} \n \
                                else if ((count of theMessagesToMove) is equal to 1) then \n \
                                --if moving one message, get the next position and move and select new message \n \
                                         set nextMessPosition to (my list_position(firstMsg, theMessages) + 1) \n \
                                         set nextMessage to (item nextMessPosition of theMessages) \n \
                                         set moveDone to my do_move(theMessagesToMove) \n \
                                         set selected messages of message viewer 1 to {nextMessage} \n \
                                else if ((count of theMessagesToMove) is greater than 1) then \n \
                                --if moving multiple messages (a conversation), try to find the next message (not 100 percent accurate given conversation and time discrepancies, move the messages and update the preview pane \n \
                                             set nextMessage to my find_next_not_selected(theMessagesToMove, theMessages) \n \
                                             set moveDone to my do_move(theMessagesToMove) \n \
                                             set selected messages of message viewer 1 to {} \n \
                                             set selected messages of message viewer 1 to {nextMessage} \n \
                                             set newMessagesToMove to the selected messages of message viewer 1 \n \
                                             set newFirstItem to (first item of newMessagesToMove) \n \
                                             return \n \
                                           end if \n \
                                         end if \n \
                                      \n \
                                      end try \n \
                                      \n \
                                      on find_next_not_selected(selectedMessages, allMessages) \n \
                                         tell application \"Mail\" to try \n \
                                         \n \
                                             set firstMsg to first item of selectedMessages \n \
                                             set firstMsgId to firstMsg's id \n \
                                             set firstMessPosition to (my list_position(firstMsg, allMessages)) \n \
                                             set nextMessPosition to (firstMessPosition + 1) \n \
                                             \n \
                                             set countOfAllMessages to (count of allMessages) \n \
                                             \n \
                                             repeat with i from nextMessPosition to countOfAllMessages \n \
                                                    set nextMessageToCheck to (item i of allMessages) \n \
                                                    set foundInSelected to my list_position(nextMessageToCheck, selectedMessages) \n \
                                                    \n \
                                                    if (foundInSelected is equal to 0) then \n \
                                                          return nextMessageToCheck \n \
                                                    end if \n \
                                             end repeat \n \
                                              \n \
                                             --If all items after this item are selected, then do not select anything \n \
                                             return {} \n \
                                        end try \n \
                                      end find_next_not_selected \n \
                                       \n \
                                      on do_move(messagesToMove) \n \
                                      tell application \"Mail\" to try \n \
                                           repeat with i from 1 to (count of messagesToMove) \n \
                                                set theMessageBeingMoved to (item i of messagesToMove) \n \
                                                set mailbox of theMessageBeingMoved to mailbox destinationFolderName of account destinationAccount \n \
                                           end repeat \n \
                                           return 1 \n \
                                      end try \n \
                                      end do_move \n \
                                      \n \
                                      on list_position(this_item, this_list) \n \
                                         repeat with i from 1 to the count of this_list \n \
                                            if item i of this_list is this_item then return i \n \
                                         end repeat \n \
                                         return 0 \n \
                                     end list_position", pathWithoutAccount, selectedItem.accountString];
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptTemplate];
    
    if (script != nil) {
        NSDictionary *error = nil;
        NSAppleEventDescriptor *result = [script executeAndReturnError:&error];
        NSLog(@"result: %@", result.stringValue);
        NSLog(@"error: %@", error);
    }
    
    
    [ButtonUtil writeArray:selectedItem];
    [ButtonUtil focusMailAndQuit];
}

-(MoveMessageButtonDelegate *) init {
    if (!myEngine) {
        myEngine = [MailEngine sharedInstance];
        isMoveButtonClicked = false;
    }
    
    return self;
}

@end
