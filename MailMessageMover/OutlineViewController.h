//
//  OutlineViewController.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mailbox.h"
#import "MoveMessageButtonDelegate.h"

@interface OutlineViewController : NSObject <NSOutlineViewDataSource>

@property (nonatomic, retain) NSMutableArray *myMailboxes;
@property (retain) IBOutlet NSOutlineView *outlineViewLocal;
@property (retain) IBOutlet MoveMessageButtonDelegate * moveDelegate;

- (IBAction) refreshTheData : (id) sender;
- (IBAction) outlineViewClicked : (id) sender;
- (IBAction) outlineViewDoubleClicked : (id) sender;

@end
