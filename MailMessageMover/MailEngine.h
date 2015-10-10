//
//  GetMailDatasource.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailEngine : NSObject {
    NSMutableArray *allAccounts;
    NSMutableArray *myMailboxes;
    NSMutableArray *allMailboxes;
    NSMutableArray *allRoots;
    NSMutableDictionary *mailboxDictionary;
}

@property (nonatomic, retain) NSMutableArray *allAccounts;
@property (nonatomic, retain) NSMutableArray *myMailboxes;
@property (nonatomic, retain) NSMutableArray *allMailboxes;
@property (nonatomic, retain) NSMutableArray *allRoots;
@property (nonatomic, retain) NSMutableDictionary *mailboxDictionary;
@property (nonatomic) NSInteger countOfVisible;
@property (nonatomic) NSInteger countOfMatched;

+ (MailEngine *) sharedInstance;

-(void) addToAccounts : (NSString *) newAccount;

-(NSMutableArray *) getAllAccounts;
-(NSMutableArray *) getMyMailboxes;

- (void) buildInitialSetofData;
- (void) createAllMailboxes : (NSAppleEventDescriptor *) result;
- (NSInteger) findMailboxesWithText : (NSString *) text;

- (NSString *) saveFilePath;
- (NSInteger) getCountOfVisible;
@end
