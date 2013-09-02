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

@synthesize lbStatus;

MailEngine *myEngine;

- (void) controlTextDidChange :(NSNotification *) sender {
    NSTextField *changedField = [sender object];
    
    //NSLog(@"in control text did change");
    
    NSString *text = [changedField stringValue];
    
    //NSLog(@"changed the label and creating the data now");

    [outlineView refreshTheData:text];
    
    myEngine = [MailEngine sharedInstance];
    //NSLog(@"first item in accounts %@", [[myEngine getAllAccounts] objectAtIndex:0] );
    
}

- (void) awakeFromNib {
    //NSLog(@"in awake from nib");
    
    myEngine = [MailEngine sharedInstance];
    NSString *message = [myEngine updateMessageInfo];
    //NSLog(@"updating label with message: %@", message);
    [lbStatus setStringValue:message];

}

@end
