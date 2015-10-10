//
//  TextFieldDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutlineViewController.h"

@interface TextFieldDelegate : NSObject {
}

@property (nonatomic, strong) IBOutlet NSTextField * userInput;
@property (retain) IBOutlet NSOutlineView *outlineView;
@property (retain) IBOutlet OutlineViewController *outlineViewDelegate;
@property (retain) IBOutlet NSWindow* theWindow;

- (IBAction) controlTextDidChange :(id) sender;

@end
