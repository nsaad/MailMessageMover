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
@synthesize myMailboxes, tbDelegate;

- (id) init {
    
    self = [super init];
    if (self) {
        myEngine = [MailEngine sharedInstance];
        [myEngine buildInitialSetofData];
        myMailboxes = [myEngine getMyMailboxes];
        
        //NSLog(@"Mailboxes contains %@", myMailboxes);
    }
    
    //NSLog(@"inited outline view controller");
    return self;
}

#pragma mark NSOutlineView Data Source Methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    
    NSInteger count = 0;
    
    if (!item) {
        for (Mailbox *m in myMailboxes) {
            if (m.visible) {
                count++;
            } else {
                //NSLog(@"Ignoring non-visible mailbox in num of children count - at top level ");
            }
        }
    } else {
        NSArray *arr = [item children];
        for (Mailbox *child in arr) {
            if (child.visible) {
                count++;
            } else {
                //NSLog(@"Ignoring non-visible mailbox in num of children count ");
            }
        }
    }
    return count;
    //    return !item ? [myMailboxes count] : [[ item children] count ];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (!item) {
        return YES;
    } else {
        NSArray *arr = [item children];
        
        NSInteger count = 0;
        for (Mailbox *child in arr) {
            if (child.visible) {
                count++;
            } else {
                //NSLog(@"Ignoring non-visible mailbox in num of children count ");
            }
        }
        
        if (count != 0) {
            return true;
        } else {
            return false;
        }
    }
    //return !item ? YES : [[item children ] count] != 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    NSInteger count = -1;
    if (!item) {
        for (Mailbox *child in myMailboxes) {
            if (child.visible) {
                count++;
            }
            
            if (count == index) {
                return child;
            }
            
        }
        //TODO there is a bug here, sometimes item is null and index is 0 and we reach the warning at the bottom 
    } else {
        NSArray *arr = [item children];
        for (Mailbox *child in arr) {
            if (child.visible) {
                count++;
            }
            
            if (count == index) {
                return child;
            }
        }
    }
    
    NSLog(@"WARNING - shouldn't arrive here - item %@ and index %lu", item, index);
    return [[Mailbox alloc] init];
    //return !item ? [myMailboxes objectAtIndex:index] : [[item children] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return [item name];
}

- (IBAction) outlineViewClicked : (id) sender {
    NSInteger rowIndex = [_outlineViewLocal clickedRow];
    id item = [_outlineViewLocal itemAtRow:rowIndex];
    //NSLog(@"CLICK HAPPENED %lu", rowIndex);
    
    Mailbox *m = item;
    
    if ([m.accountString isEqualToString:@""] || m.accountString == NULL) {
        if ([m children]) {
            
            //NSLog(@"Item has children");
        
            //NSLog(@"Current clicked row: %lu", rowIndex);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(rowIndex + 1)];
        
            //NSLog(@"Setting selected row to %lu", (rowIndex + 1));
            [_outlineViewLocal selectRowIndexes:indexSet byExtendingSelection:NO];
            [_outlineViewLocal scrollRowToVisible:rowIndex + 1];
        }
    }
    
}

- (void) awakeFromNib {
    
    [_outlineViewLocal setDoubleAction:@selector(onDoubleClick:)];
    NSLog(@"OutlineViewController awakeFromNib");
}

- (IBAction) onDoubleClick : (id) sender {
    NSLog(@"in double click");
    Mailbox *selectedItem = [_outlineViewLocal itemAtRow:[_outlineViewLocal selectedRow]];
    NSLog(@"selected item is: %@", [selectedItem name]);
    [tbDelegate moveTheMessage : selectedItem];
    
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    
    Mailbox *m = item;
    
        //NSLog(@"In shouldSelectItem method %@:%@", m.name, m.accountString);
    
    if ([m.accountString isEqualToString:@""] || m.accountString == NULL) {
        //NSLog(@"Account of mailbox %@ is empty, isn't it %@", m.name, m.accountString);
        
        [outlineView expandItem:item];
        //NSLog(@"Expanded item");
        
        return NO;
    }

    return YES;
}

- (IBAction) refreshTheData : (NSString *) text {
    
    //NSLog(@"in refreshTheData");
    
    NSInteger countOfMatched = [myEngine findMailboxesWithText:text];

    for (Mailbox *m in myMailboxes) {
        [self expandAllItems:m];
    }
    [self.outlineViewLocal reloadData];
    
    NSInteger exactMatch = 1;
    NSLog(@"in refresh, countOfMatched: %lu", countOfMatched);
    if (countOfMatched == exactMatch) {
        NSInteger rowToSelect = [myEngine getCountOfVisible];
        NSLog(@"Only one match - count of visible %lu", rowToSelect);
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(rowToSelect -1)];
        [_outlineViewLocal selectRowIndexes:indexSet byExtendingSelection:NO];
        [_outlineViewLocal scrollRowToVisible:rowToSelect];
    } else {
        NSLog(@"In refresh, more then one match");
    }
}

-(void) expandAllItems: (Mailbox *) m {
    [self.outlineViewLocal expandItem:m];
    if (m.children) {
        for (Mailbox *child in m.children) {
            [self expandAllItems:child];
        }
    }
}

//- (void) keyDown:(NSEvent *)event {
//    NSLog(@"In key down on outline view");
//}
//
//- (void) mouseDown:(NSEvent *)event {
//    NSLog(@"In mouse down on outline view");
//}
//
//
//- (BOOL)acceptsFirstResponder
//{
//    NSLog(@"in accepts first responder");
//    return YES;
//};
//
//-(BOOL)canBecomeFirstResponder {
//    NSLog(@"in can become first responder");
//    return YES;
//}
//
//-(BOOL)becomeFirstResponder {
//    NSLog(@"in  become first responder");
//    return YES;
//}

@end
