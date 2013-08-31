//
//  Mailbox.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "Mailbox.h"

@implementation Mailbox

- (id) init {
    return [self initWithName:@"Test mailbox"];
}

- (id) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];
        _children = [[ NSMutableArray alloc] init];
        _parent = nil;
        _parentString = nil;
        _account = nil;
        _accountString = nil;
        _visible = true;
        _duplicateName = false;
    }
    
    return self;
}

- (void) addChild:(Mailbox *)child {
    [_children addObject:child];
}

- (id)copyWithZone:(NSZone *)zone
{
    Mailbox *copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        for (Mailbox *child in self.children) {
            Mailbox *childCopy = [child copyWithZone:zone];
            [copy addChild: childCopy];
        }
        [copy setParent:[[self.parent copyWithZone:zone] autorelease]];
        [copy setAccount:[[self.account copyWithZone:zone] autorelease]];
        
        // Set primitives
        [copy setName:self.name];
        [copy setParentString:self.parentString];
        [copy setAccountString:self.accountString];
        [copy setVisible:self.visible];
        [copy setDuplicateName:self.duplicateName];
    }
    
    return copy;
}
@end
