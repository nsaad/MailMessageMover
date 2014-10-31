//
//  ViewTextFieldDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 02/09/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "ViewTextFieldDelegate.h"

@implementation ViewTextFieldDelegate

@synthesize viewTextField;

- (void)textDidBeginEditing:(NSNotification *)aNotification {
    NSLog(@"In text did beging editting");
}

@end
