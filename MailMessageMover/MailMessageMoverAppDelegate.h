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

@interface MailMessageMoverAppDelegate : NSObject

@property (nonatomic, strong) IBOutlet NSWindow * window;
@property (nonatomic, strong) IBOutlet NSTextField * inputField;
@property (retain) IBOutlet TextFieldDelegate * tfDelegate;
@property (retain) IBOutlet MailSubjectLabelDelegate * mslDelegate;

- (IBAction) quitApplication:(id)sender;

@end
