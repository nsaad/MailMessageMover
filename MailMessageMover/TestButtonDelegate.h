//
//  TestButtonDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestButtonDelegate : NSObject

@property (retain) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) IBOutlet NSTextField * lbStatus;
@property (nonatomic, strong) IBOutlet NSButton * moveMessageButton;
@property (nonatomic, strong) IBOutlet NSButton * goToFolderButton;

- (IBAction)moveMessageButtonClicked:(id)sender;
- (IBAction)goToFolderButtonClicked:(id)sender;

@end
