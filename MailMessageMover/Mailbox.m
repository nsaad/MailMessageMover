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
    }
    
    return self;
}

- (void) addChild:(Mailbox *)child {
    [_children addObject:child];
}


@end
