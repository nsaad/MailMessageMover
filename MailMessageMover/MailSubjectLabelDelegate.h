//
//  MailSubjectLabelDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailSubjectLabelDelegate : NSObject {
}

//Label that this delegate handles
@property (nonatomic, strong) IBOutlet NSTextField * lbStatus;

//error label to show when no messages are selected
@property (nonatomic, strong) IBOutlet NSTextField * errorLabel;

//access to move button to disable if no messages are selected
@property (nonatomic, strong) IBOutlet NSButton * moveButton;

- (void) awakeFromNib;

@end
