//
//  OutlineViewController.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "OutlineViewController.h"
#import "MailEngine.h"

@implementation OutlineViewController

MailEngine *myEngine;
@synthesize myMailboxes;

- (id) init {
    
    self = [super init];
    if (self) {
        myEngine = [MailEngine sharedInstance];
        [myEngine buildInitialSetofData];
        myMailboxes = [myEngine getMyMailboxes];
        
        NSLog(@"Mailboxes contains %@", myMailboxes);
    }
    
    NSLog(@"inited outline view controller");
    return self;
}

#pragma mark NSOutlineView Data Source Methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return !item ? [myMailboxes count] : [[ item children] count ];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return !item ? YES : [[item children ] count] != 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return !item ? [myMailboxes objectAtIndex:index] : [[item children] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return [item name];
}

- (IBAction) refreshTheData : (NSString *) text {
    
    NSLog(@"in refreshTheData");
    
    [myEngine findMailboxesWithText:text];
    
    //Sample code used to add a new item to the list when text is editted.
    /*
    Mailbox *m = [self.outlineViewLocal itemAtRow:[self.outlineViewLocal selectedRow]];
    if (m) {
        [m addChild:[[Mailbox alloc] init]];
        [self.outlineViewLocal expandItem:m];
    }
    else
        [myMailboxes addObject:[[Mailbox alloc] init]];
     */
    
    NSLog(@"running reloadData");
    [self.outlineViewLocal reloadData];
}

/*- (IBAction) changeData : (id) sender {
    NSLog(@"changing the data");
    [self.mailboxes addObject:[[Mailbox alloc] initWithName:@"Test mailbox"]];
    [self.outlineView reloadData];
}
*/
@end
