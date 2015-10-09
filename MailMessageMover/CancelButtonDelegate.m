//
//  TestButtonDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "CancelButtonDelegate.h"
#import "ButtonUtil.h"

@implementation CancelButtonDelegate

@synthesize cancelButton;

- (IBAction) cancelButtonClicked:(id) sender {
    [ButtonUtil focusMailAndQuit];
}

@end
