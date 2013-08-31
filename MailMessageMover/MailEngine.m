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

NSMutableArray *allRoots;
//NSMutableArray *allLeaves;

static MailEngine *_sharedInstance;
@synthesize allAccounts, allMailboxes, allRoots, myMailboxes, mailboxDictionary;

+ (MailEngine *) sharedInstance
{
    if (!_sharedInstance) {
        _sharedInstance = [[MailEngine alloc] init];
    }
    
    return _sharedInstance;
}

-(MailEngine *) init {
    allAccounts = [[NSMutableArray alloc] init];
    allRoots = [[NSMutableArray alloc] init];
    myMailboxes = [[NSMutableArray alloc] init];
    allMailboxes = [[NSMutableArray alloc] init];
    mailboxDictionary = [[NSMutableDictionary alloc] init];
    
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
    
    if (allAccounts) {
        //NSLog(@"passing in %@", newAccount);
        [allAccounts addObject:newAccount];
        //NSLog(@"all accounts now has %ld", [allAccounts count]);
    } else {
        NSLog(@"allAccounts is still nil");
    }
}

-(void) buildInitialSetofData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"getAllMailboxes" ofType:@"scpt"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        
        [self createAllMailboxes:result];
    }
    
    for (Mailbox *m in allRoots) {
        [myMailboxes addObject:m];
    }
}

-(void) createAllMailboxes : (NSAppleEventDescriptor *) result {
    NSInteger num = [result numberOfItems];
    //NSLog(@"There are %ld items in the list.", num);
    
    for (NSInteger idx = 1; idx <= num; ++idx) {
        NSAppleEventDescriptor *item = [result descriptorAtIndex:idx];
        //NSLog(@"item == %@", item);
        
        NSInteger internalNum = [item numberOfItems];
        //NSLog(@"There are %ld items in the internal list.", internalNum);
        
        for (NSInteger internalIdx = 1; internalIdx <= internalNum; ++internalIdx) {
            NSAppleEventDescriptor *internalItem = [item descriptorAtIndex:internalIdx];
            //NSLog(@"internalItem at %lu is: %@", internalIdx, internalItem);
            
            NSString *path = [[internalItem descriptorAtIndex:3] stringValue];
            NSString *account = [[[internalItem descriptorAtIndex:4] descriptorAtIndex:3] stringValue];
            
            //NSLog(@"Path is: %@", path);
            //NSLog(@"Account is: %@", account);
            
            NSString *name;
            NSString *parentPath;
            
            NSRange match = [path rangeOfString: @"/" options:NSBackwardsSearch];
            if (match.location == NSNotFound) {
                //NSLog (@"No / found, a top level folder under the account %@", account);
                //parent set to account
                parentPath = account;
                //set path as name
                name = path;
            } else {
                //NSLog (@"Found / at index %lu", match.location);
                
                //extract after / and set as name
                name = [path substringWithRange: NSMakeRange (match.location + 1, [path length] - match.location - 1)];
                
                //NSLog(@"Name is: %@", name);
                
                //extract first / and set as parent
                parentPath = [path substringWithRange: NSMakeRange (0, match.location)];
                //NSLog(@"Parent Path is %@", parentPath);
                
                //check for another / and get direct parent if exists
                match = [parentPath rangeOfString: @"/" options:NSBackwardsSearch];
                if (match.location == NSNotFound) {
                    //NSLog(@"No other parents in the path, already found exact parent");
                } else {
                    //NSLog(@"Another / is found, getting the direct parent of this mailbox");
                    parentPath = [parentPath substringFromIndex:match.location + 1];
                    //NSLog(@"Final parent Path is %@", parentPath);
                }
                
            }
            
            //Create a mailbox
            Mailbox *m = [[ Mailbox alloc] initWithName:name];
            m.parentString = parentPath;
            m.accountString = account;
            
            NSLog(@"Created mailbox: %@ under %@ in %@ [key: %@]" , name, parentPath, account, name);
            
            [self addUniqueMailboxToDictionary: mailboxDictionary : m];
            
        }
    }
    
    NSLog(@"Before account folders, there are %lu mailboxes in the dictionary", [mailboxDictionary count]);
    
    [self createAccountFolders];
    //Check what's in the dictionary at the end of the job
    NSLog(@"There are %lu mailboxes in the dictionary", [mailboxDictionary count]);
    
    
    [self connectAllParents];
    //NSLog(@"All roots contains: %lu", (unsigned long)[allRoots count]);
    
    for (Mailbox *m in allRoots) {
        [self sortNodeChildren: m];
    }

}

-(void) sortNodeChildren : (Mailbox *) m {
    if (m.children) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        //NSLog(@"Sorting children of %@", m.name);
        [m.children sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        for (Mailbox *child in m.children) {
            [self sortNodeChildren : child];
        }
    } else {
        //NSLog(@"Finished sorting children of %@", m.name);
    }
}

- (void) findMailboxesWithText: (NSString *) text {
    
    NSMutableArray *copyToUpdate = [[NSMutableArray alloc] initWithArray:allRoots copyItems:YES];
    for (Mailbox *m in copyToUpdate) {
        NSLog(@"name in copy: %@", m.name);
        m.name = @"My test";
        
//        [self updateNodeAndChildrenVisibility: m];
    }
    NSLog(@"and in original allRoots:");
    for (Mailbox *m in copyToUpdate) {
        NSLog(@"name in allRoots: %@", m.name);
    }
    
    //update myMailboxes to have 
}

-(void) addUniqueMailboxToDictionary : (NSMutableDictionary *) dict : (Mailbox *) m {
    
    //Add it to the NSDictionary.
    if ([dict objectForKey:m.name]) {
        m.duplicateName = true;
        NSLog(@"WARNING: There's already an object set with key \"%@\"! Trying with key %@_%@", m.name, m.parentString, m.name);
        
        NSArray *stringToJoin = [[NSArray alloc] initWithObjects:m.parentString, m.name, nil];
        NSString *compoundKey = [stringToJoin componentsJoinedByString:@"_"];
        if ([mailboxDictionary objectForKey:compoundKey]) {
            NSLog(@"MAJOR WARNING: Even with compound key there's duplication - fix this in Mail for %@ in %@ in %@", m.name, m.parentString, m.account);
        } else {
            [mailboxDictionary setObject:m forKey:compoundKey ];
            
            Mailbox *tempMailbox = [mailboxDictionary objectForKey:m.name];
            tempMailbox.duplicateName = true;
            
            NSArray *stringToJoin = [[NSArray alloc] initWithObjects:tempMailbox.parentString, tempMailbox.name, nil];
            NSString *compoundKey = [stringToJoin componentsJoinedByString:@"_"];
            
            if ([mailboxDictionary objectForKey:compoundKey]) {
                NSLog(@"MAJOR WARNING: The temp mailbox being modifiy has compound key duplication - fix this in Mail for %@ in %@ in %@", m.name, m.parentString, m.accountString);
            } else {
                NSLog(@"Successfully updated to new key [%@] for mailbox %@ under %@ in %@", compoundKey, tempMailbox.name, tempMailbox.parentString, tempMailbox.accountString);
                [mailboxDictionary setObject:tempMailbox forKey:compoundKey ];
                [mailboxDictionary removeObjectForKey:tempMailbox.name];
            }
            
        }
        
    } else {
        [mailboxDictionary setObject:m forKey:m.name ];
    }
}

-(void) createAccountFolders {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"getAllAccounts" ofType:@"scpt"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        
        NSInteger num = [result numberOfItems];
        for (NSInteger idx = 1; idx <= num; ++idx) {
            NSAppleEventDescriptor *item = [result descriptorAtIndex:idx];
            NSString *str = [item stringValue];
            //NSLog(@"str == %@", str);
            
            [self addToAccounts:str];
            
        }
        
    }
    
    for (NSString* str in allAccounts)
    {
        NSLog(@"Processing account %@", str);
        Mailbox *m = [[Mailbox alloc] initWithName:str];
        if ([mailboxDictionary objectForKey:str]) {
            NSLog(@"MAJOR WARNING: Account name %@ is duplicated somewhere -- fix this", str);
        } else {
            [mailboxDictionary setObject:m forKey:str];
            //Added to allRoots to be able to start from the top
            [allRoots addObject:m];
        }
    }
}

-(void) connectAllParents {
    NSLog(@"In connect relatives");
    
    for(id key in mailboxDictionary) {
        Mailbox *box = [mailboxDictionary objectForKey:key];
        NSLog(@"first key: %@", key);
        NSString *parentString = box.parentString;
                NSLog(@"first parent: %@", parentString);
        
        if (parentString != nil) {
            Mailbox *parent = [mailboxDictionary objectForKey:parentString];
            NSLog(@"got parent object: %@", parent);
            if (parent == nil) {
                
                NSArray *stringToJoin = [[NSArray alloc] initWithObjects:box.accountString, box.parentString, nil];
                NSString *compoundKey = [stringToJoin componentsJoinedByString:@"_"];
                NSLog(@"Trying with compound key %@", compoundKey);

                parent = [mailboxDictionary objectForKey:compoundKey];
                if (parent == nil) {
                    //NSLog(@"MAJOR WARNING, parent folder %@ not found in dictionary", parentString);
                    NSLog(@"Dealing with top level account [%@], adding to root list.", box.name);
                    //TODO add to root list
                } else {
                    box.parent = parent;
                    [parent addChild:box];
                }
            } else {
                box.parent = parent;
                [parent addChild:box];
            }
        }
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
