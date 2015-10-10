//
//  Mailbox.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mailbox : NSObject <NSCopying>

@property (copy) NSString *name;
@property (readonly, copy) NSMutableArray *children;
@property Boolean visible;
@property (assign) Mailbox *parent;
@property (assign) Mailbox *account;

@property (copy) NSString * accountString;
@property (copy) NSString * parentString;

@property (copy) NSString * fullPath;
@property Boolean duplicateName;

- (id) initWithName : (NSString *) name;
- (id) initWithName : (NSString *) name_ : (NSString *) parentPath_ : (NSString *) account_ : (NSString *) path_;
- (void) addChild : (Mailbox *) child;
- (void) setParent : (Mailbox *) parent;
@end
