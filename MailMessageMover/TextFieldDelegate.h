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
    IBOutlet OutlineViewController *outlineView;
}

@property (nonatomic, strong) IBOutlet NSTextField * testLabel;
@property (nonatomic, strong) IBOutlet NSTextField * userInput;
@property (nonatomic, strong) IBOutlet NSTextField * lbStatus;

- (IBAction) controlTextDidChange :(id) sender;
- (IBAction) controlTextDidBeginEditing:(NSNotification *)obj :(id)sender;
- (void) awakeFromNib;

@end
