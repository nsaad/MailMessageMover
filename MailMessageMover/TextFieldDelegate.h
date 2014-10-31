//
//  TextFieldDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutlineViewController.h"
#import "TestButtonDelegate.h"

@interface TextFieldDelegate : NSObject {
}

@property (nonatomic, strong) IBOutlet NSTextField * userInput;
@property (nonatomic, strong) IBOutlet NSTextField * lbStatus;
@property (nonatomic, strong) IBOutlet NSTextField * lbMessageCount;
@property (nonatomic, strong) IBOutlet NSTextField * errorLabel;
@property (nonatomic, strong) IBOutlet NSButton * moveButton;
@property (retain) IBOutlet NSOutlineView *outlineView;
@property (retain) IBOutlet OutlineViewController *outlineViewDelegate;
@property (retain) IBOutlet NSWindow* theWindow;

- (IBAction) controlTextDidChange :(id) sender;
- (void) awakeFromNib;
- (void) changeFocusToView;

@end
