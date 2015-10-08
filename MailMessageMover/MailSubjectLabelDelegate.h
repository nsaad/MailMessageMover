//
//  MailSubjectLabelDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutlineViewController.h"

@interface MailSubjectLabelDelegate : NSObject {
}

@property (nonatomic, strong) IBOutlet NSTextField * lbStatus;
@property (nonatomic, strong) IBOutlet NSTextField * errorLabel;
@property (nonatomic, strong) IBOutlet NSButton * moveButton;

- (void) awakeFromNib;

@end
