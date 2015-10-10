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

NSInteger countOfMatched;

static MailEngine *_sharedInstance;
@synthesize allAccounts, allMailboxes, allRoots, myMailboxes, mailboxDictionary, countOfVisible, countOfMatched;

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
                
                //Setting parent path to the full path of the parent to handle duplicates.
                //This is also used by connectParents method
                parentPath = [path substringWithRange: NSMakeRange (0, match.location)];
                parentPath = [NSString stringWithFormat: @"%@/%@", account, parentPath];
                //NSLog(@"Parent Path is %@", parentPath);
                
            }
            
            //Create a mailbox with full path as Account/path to have a fully unique path to use for the dictionary
            Mailbox *m = [[ Mailbox alloc] initWithName:name : parentPath : account : [NSString stringWithFormat: @"%@/%@", account, path]];
            
            //NSLog(@"Created mailbox: [%@] with parent [%@] in account [%@] using key [%@]" , name, parentPath, account, [NSString stringWithFormat: @"%@/%@", account, path]);
            
            [self addUniqueMailboxToDictionary: mailboxDictionary : m];
            
        }
    }
    
    //NSLog(@"Before account folders, there are %lu mailboxes in the dictionary", [mailboxDictionary count]);
    
    [self createAccountFolders];
    //Check what's in the dictionary at the end of the job
    //NSLog(@"There are %lu mailboxes in the dictionary", [mailboxDictionary count]);
    
    
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

//Recursively look through the mailboxes for a mailbox with TEXT in the name
- (NSInteger) findMailboxesWithText: (NSString *) text {
    
    countOfMatched = 0;
    countOfVisible = 0;
    
    for (Mailbox *m in allRoots) {
        
        [self updateNodeAndChildrenVisibility: m : text];
    }
    
    return countOfMatched;
    
}

//Sets a node to visible if it contains TEXT or if it has a child that contains TEXT
- (BOOL) updateNodeAndChildrenVisibility : (Mailbox *) m : (NSString *) text {

    //Check for TEXT in this node and set it's visibility accordingly
    if ([text isEqualToString:@""]) {
        //NSLog(@"Text is empty, so setting to visible");
        m.visible = true;
    } else if ([m.fullPath rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound && [m.fullPath rangeOfString:text options:NSCaseInsensitiveSearch].location != NULL) {
        countOfMatched++;
        //NSLog(@"Found text %@ in %@ -- count of matched %lu", text, m.fullPath, countOfMatched);
        m.visible = true;
    } else {
        m.visible = false;
    }
    
    //Recurse over this nodes children to see if they have any visible children
    NSArray *arr = m.children;
    BOOL anyChildVisible = false;
    //NSLog(@"m.name has %@ children %lu", m.name, [m.children count]);
    for (Mailbox *child in arr) {
        if ([self updateNodeAndChildrenVisibility : child : text]) {
            anyChildVisible = true;
        }
    }
    
    //If it has visible children, set this node to visible regardless
    if (anyChildVisible) {
        m.visible = true;
    }
    
    if (m.visible) {
        countOfVisible++;
    }
    
    return m.visible;
    
}

//Add new mailboxes into the dictonary using the full path of the mailbox as the unique identifier to allow for duplicate folder names
-(void) addUniqueMailboxToDictionary : (NSMutableDictionary *) dict : (Mailbox *) m {
    
    //Add it to the NSDictionary.
    //NSLog(@"Adding mailbox %@ with full path %@ to dictionary", m.name, m.fullPath);
    if ([dict objectForKey:m.fullPath]) {
        m.duplicateName = true;
        NSLog(@"WARNING: There's already an object set with key \"%@\"! Code needs revision", m.fullPath);
    } else {
        [mailboxDictionary setObject:m forKey:m.fullPath ];
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
        //NSLog(@"Processing account %@", str);
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
    //NSLog(@"In connect relatives");
    
    //Iterate over all the mailboxes that exist in the dictionary
    for(id key in mailboxDictionary) {
        
        //Get a mailbox
        Mailbox *box = [mailboxDictionary objectForKey:key];
        //NSLog(@"first key: %@", key);
        
        //Get the mailbox's parent
        NSString *parentString = box.parentString;
        //NSLog(@"first parent: %@", parentString);
        
        //As long as there is a parentString
        if (parentString != nil) {
            
            //Look for the parent mailbox in the dictionary using the parentString as the key
            Mailbox *parent = [mailboxDictionary objectForKey:parentString];
            //NSLog(@"got parent object: %@", parent.name);
            
            //If we find the parent mailbox object
            if (parent != nil) {
                
                //Create the two way connection between the parent and the child
                box.parent = parent;
                [parent addChild:box];
            } else {
                //NSLog(@"WARNING: We should always find the parent in the dictionary, code review required.");
            }
        }
    }
}

//Provides the path to the location of the plist file used to store the last searched for folder
-(NSString*) saveFilePath{
    //NSLog(@"In save file path method");
    
    NSString* path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/lastSearch.plist"];
    return path;
}

- (NSInteger) getCountOfVisible {
    return countOfVisible;
}

@end
