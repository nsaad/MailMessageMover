//
//  OutlineViewController.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mailbox.h"
#import "TestButtonDelegate.h"

@interface OutlineViewController : NSObject <NSOutlineViewDataSource>

@property (retain) IBOutlet TestButtonDelegate *tbDelegate;
@property (nonatomic, retain) NSMutableArray *myMailboxes;
@property (retain) IBOutlet NSOutlineView *outlineViewLocal;

- (IBAction) refreshTheData : (id) sender;
- (IBAction) outlineViewClicked : (id) sender;
- (IBAction) outlineViewDoubleClicked : (id) sender;
//- (IBAction) changeData: (id) sender;
//- (IBAction) setBaseData: (id) sender;

@end
