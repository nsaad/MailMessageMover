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
}

@property (nonatomic, retain) NSMutableArray *allAccounts;
@property (nonatomic, retain) NSMutableArray *myMailboxes;
@property (nonatomic, retain) NSMutableArray *allMailboxes;

+ (MailEngine *) sharedInstance;

-(void) addToAccounts : (NSString *) newAccount;
-(NSMutableArray *) getAllAccounts;

-(NSMutableArray *) getMyMailboxes;

- (void) createFakeData;
- (void) getFoldersFromMail : (NSString *) searchText;
@end
