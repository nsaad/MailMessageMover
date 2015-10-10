//
//  MailMessageMoverAppDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 02/09/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextFieldDelegate.h"
#import "MailSubjectLabelDelegate.h"
@class WindowController;

@interface MailMessageMoverAppDelegate : NSObject<NSApplicationDelegate>

@property (nonatomic, strong) IBOutlet NSTextField * inputField;
@property (retain) IBOutlet TextFieldDelegate * tfDelegate;
@property (retain) IBOutlet NSWindow *window;

- (IBAction) quitApplication:(id)sender;

@end
