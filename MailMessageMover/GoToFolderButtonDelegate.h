//
//  TestButtonDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mailbox.h"
#import "ButtonUtil.h"

@interface GoToFolderButtonDelegate : NSObject

@property (retain) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) IBOutlet NSButton * goToFolderButton;

- (IBAction) goToFolderButtonClicked:(id)sender;
 
@end
