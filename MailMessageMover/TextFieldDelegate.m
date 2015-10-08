//
//  TextFieldDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "TextFieldDelegate.h"
#import "OutlineViewController.h"
#import "MailEngine.h"
#import "TestButtonDelegate.h"

@implementation TextFieldDelegate

@synthesize lbStatus, lbMessageCount, outlineView, outlineViewDelegate, theWindow, userInput, errorLabel, moveButton;

MailEngine *myEngine;
static int TextFieldKVOContext = 0;

- (void) controlTextDidChange :(NSNotification *) sender {
    NSTextField *changedField = [sender object];
    
    //NSLog(@"in control text did change");
    
    NSString *text = [changedField stringValue];
    
    //NSLog(@"changed the label and creating the data now");

    [outlineViewDelegate refreshTheData:text];
    
    myEngine = [MailEngine sharedInstance];
    //NSLog(@"first item in accounts %@", [[myEngine getAllAccounts] objectAtIndex:0] );
    
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{
    BOOL retval = NO;
    
    if (commandSelector == @selector(deleteBackward:)) {
        
        retval = YES; // causes Apple to NOT fire the default enter action
        //[self controlTextDidChange : fieldEditor];
//        NSTextField *changedField = [self ];
        
        NSLog(@"in doCommandBySelector method");
        NSInteger insertionPoint = [[[fieldEditor selectedRanges] objectAtIndex:0] rangeValue].location;
        NSLog(@"fieldEditor %lu", insertionPoint);
        
        NSString *text = [[fieldEditor textStorage] string];
        NSString *before = [text substringToIndex:insertionPoint - 1];
        NSString *after = [text substringFromIndex:insertionPoint];
        NSString *modifiedText = [before stringByAppendingString: after];
        NSLog(@"text %@", text);
        
        [outlineViewDelegate refreshTheData:modifiedText];
        
        NSInteger rowToSelect = [myEngine getCountOfVisible];
        
        //TODO - to highlight pushes the WARNING error to manifest itself
        //NSInteger countOfMatched = [myEngine findMailboxesWithText:text];
        //if (countOfMatched == 1) {
         //   [self changeFocusToView];
        //}
        
       [self expandOutlineViewOnChange : rowToSelect];
        //NSLog(@"after delete, should be: %@%@", modifiedText);
        
        [fieldEditor setString: modifiedText];
        [fieldEditor setSelectedRange: NSMakeRange(insertionPoint - 1, 0)];
  //      NSString *text = [changedField stringValue];
        
        //NSLog(@"changed the label and creating the data now");
    //    [outlineViewDelegate refreshTheData:text];
        
    } //else if (commandSelector == @selector(insertNewline::)) {
      //  NSLog(@"in doCommandBySelector with new line");
      //  [self changeFocusToView];
   // }
    
    NSLog(@"Selector = %@", NSStringFromSelector( commandSelector ) );
    
    return retval;  
}

- (void) controlTextDidEndEditing : (NSNotification *) sender {
    NSLog(@"in control text end");
    //TestButtonDelegate *tbd = [[TestButtonDelegate alloc] init];
    //[tbd moveMessageButtonClicked:sender];
    [self changeFocusToView];
}

- (void) changeFocusToView {
    
    NSInteger exactMatch = 1;
    NSInteger matched = [myEngine countOfMatched];
    NSLog(@"in refresh, countOfMatched: %lu", matched);
    if (matched == exactMatch) {
        NSInteger rowToSelect = [myEngine getCountOfVisible];
        NSLog(@"Only one match - count of visible %lu", rowToSelect);
        
        [self expandOutlineViewOnChange : rowToSelect];
        
    } else {
        NSLog(@"In refresh, more then one match");
        [self expandOutlineViewOnChange : 2];
    }
    
    
   // NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(0)];
    //[outlineView selectRowIndexes:indexSet byExtendingSelection: NO];
   // NSLog(@"Selecting row with index 0");
    
    [theWindow makeFirstResponder:outlineView];
}

- (void) expandOutlineViewOnChange : (NSInteger) rowToSelect {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(rowToSelect - 1)];
    
    //Get the node to expand if necessary
    NSTreeNode *node = [outlineView itemAtRow:rowToSelect];
    if ([outlineView isItemExpanded:node]) {
        NSLog(@"it isn't expanded");
        [outlineView expandItem:node expandChildren:YES];
    } else {
        NSLog(@"it is expanded");
    }
    
    //Make the appropriate selection
    [outlineView selectRowIndexes:indexSet byExtendingSelection:NO];
    [outlineView scrollRowToVisible:rowToSelect];
}


- (void) awakeFromNib {
    //NSLog(@"in awake from nib");
    
    myEngine = [MailEngine sharedInstance];
    NSString *message = [myEngine updateMessageInfo];
    //NSLog(@"updating label with message: %@", message);
    [lbStatus setStringValue:message];
    
    NSString *messageCount = [myEngine updateMessageCount];
    
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

    NSRange range = [message rangeOfString:@"No message selected" options:NSCaseInsensitiveSearch];
    //NSLog(@"rnage location: %lu", range.location);
    
    if (range.location != NSNotFound) {
        [errorLabel setStringValue:@"No messages selected, moving not an option."];
        [moveButton setEnabled:false];
    }
    
    if (userInput) {
        [self.userInput addObserver:self
                         forKeyPath:@"stringValue"
                            options:NSKeyValueObservingOptionNew
                            context:&TextFieldKVOContext];
    }
    
    [theWindow makeFirstResponder:userInput];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"in observe, object is %@", object);
    
    if (context != &TextFieldKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (object == self.userInput) {
        if ([keyPath isEqualToString:@"stringValue"]) {
            NSLog(@"i'm aware the string got set: %@", [userInput stringValue]);
            [outlineViewDelegate refreshTheData:[userInput stringValue]];
            //[self changeFocusToView];
        }
    }
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL)canBecomeKeyView {
    return  YES;
}

@end
