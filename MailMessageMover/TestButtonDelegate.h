//
//  TestButtonDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mailbox.h"

@interface TestButtonDelegate : NSObject

@property (retain) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) IBOutlet NSTextField * lbStatus;
@property (nonatomic, strong) IBOutlet NSTextField * errorLabel;
@property (nonatomic, strong) IBOutlet NSButton * moveMessageButton;
@property (nonatomic, strong) IBOutlet NSButton * goToFolderButton;

- (IBAction) moveMessageButtonClicked:(id)sender;
- (void) moveTheMessage : (Mailbox *) selectedItem;
- (IBAction) goToFolderButtonClicked:(id)sender;

@end
