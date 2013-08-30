//
//  Mailbox.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mailbox : NSObject

@property (copy) NSString *name;
@property (readonly, copy) NSMutableArray *children;

- (id) initWithName : (NSString *) name;
- (void) addChild : (Mailbox *) child;
@end
