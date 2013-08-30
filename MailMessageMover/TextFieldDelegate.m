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

@implementation TextFieldDelegate
@synthesize testLabel;

- (void) controlTextDidChange :(NSNotification *) sender {
    NSTextField *changedField = [sender object];
    
    NSLog(@"in control text did change");
    
    NSString *text = [changedField stringValue];
    [testLabel setStringValue:text];
    
    NSLog(@"changed the label and creating the data now");

    [outlineView refreshTheData:sender];
    
    MailEngine *myEngine = [MailEngine sharedInstance];
    NSLog(@"first item in accounts %@", [[myEngine getAllAccounts] objectAtIndex:0] );
    
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSLog(@"in end editting");
    return;
}

- (IBAction) controlTextDidBeginEditing:(NSNotification *)obj :(id)sender {
    NSLog(@"In get all mailboxes");
}

@end
