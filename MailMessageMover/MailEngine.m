//
//  GetMailDatasource.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "MailEngine.h"
#import "Mailbox.h"

@implementation MailEngine

NSMutableArray *myMailboxes;
NSMutableArray *allMailboxes;
NSMutableArray *allAccounts;

static MailEngine *_sharedInstance;
@synthesize allAccounts, allMailboxes, myMailboxes;

+ (MailEngine *) sharedInstance
{
    if (!_sharedInstance) {
        _sharedInstance = [[MailEngine alloc] init];
    }
    
    return _sharedInstance;
}

-(MailEngine *) init {
    allAccounts = [[NSMutableArray alloc] init];
    myMailboxes = [[NSMutableArray alloc] init];
    allMailboxes = [[NSMutableArray alloc] init];
    
    return self;
}

-(NSMutableArray *) getAllAccounts {
    return allAccounts;
}

-(NSMutableArray *) getMyMailboxes {
    return myMailboxes;
}

-(NSMutableArray *) getAllMailboxes {
    return allMailboxes;
}

-(void) addToAllMailboxes : (NSString *) newMailbox {
    
}

-(void) addToAccounts : (NSString *) newAccount {
    NSLog(@"allAccounts is in %@", allAccounts);
    if (allAccounts) {
        NSLog(@"passing in %@", newAccount);
        [allAccounts addObject:newAccount];
        NSLog(@"all accounts now has %ld", [allAccounts count]);
    } else {
        NSLog(@"allAccounts is still nil");
    }
}

-(void) createFakeData {

        myMailboxes = [[NSMutableArray alloc] init];
        
        Mailbox *account1 = [[Mailbox alloc] initWithName:@"Red Hat"];
        Mailbox *account2 = [[Mailbox alloc] initWithName:@"Gmail"];
        
        [account1 addChild:[[Mailbox alloc] initWithName:@"Lists"]];
        [account1 addChild:[[Mailbox alloc] initWithName:@"Departments"]];
        
        Mailbox *clients = [[Mailbox alloc] initWithName:@"Clients"];
        [account1 addChild:clients];
        
        [clients addChild:[[Mailbox alloc] initWithName:@"Tesco Bank"]];
        [clients addChild:[[Mailbox alloc] initWithName:@"British Airways"]];
        [clients addChild:[[Mailbox alloc] initWithName:@"Vodafone"]];
        
        [account2 addChild:[[Mailbox alloc] initWithName:@"Family"]];
        [account2 addChild:[[Mailbox alloc] initWithName:@"Friends"]];
        [account2 addChild:[[Mailbox alloc] initWithName:@"Elisa"]];
        [account2 addChild:[[Mailbox alloc] initWithName:@"British Airways"]];
        
        [myMailboxes addObject:account1];
        [myMailboxes addObject:account2];
    
    NSLog(@"my mailboxes count %ld", [myMailboxes count]);
        NSLog(@"created fake data");
}

- (void) getFoldersFromMail : (NSString *)searchText {
    NSLog(@"accessing mail, looking for seachText:");
}

@end
