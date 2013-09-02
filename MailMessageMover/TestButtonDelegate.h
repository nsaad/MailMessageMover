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
@property (nonatomic, strong) IBOutlet NSTextField * errorLabel;
@property (nonatomic, strong) IBOutlet NSButton * moveMessageButton;
@property (nonatomic, strong) IBOutlet NSButton * goToFolderButton;
@property (nonatomic, strong) IBOutlet NSButton * cancelButton;

- (IBAction)moveMessageButtonClicked:(id)sender;
- (IBAction)goToFolderButtonClicked:(id)sender;
- (IBAction) cancelButtonClicked:(id) sender;

@end
