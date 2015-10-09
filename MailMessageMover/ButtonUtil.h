//
//  TestButtonDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mailbox.h"

@interface ButtonUtil : NSObject

+ (BOOL) checkIfItemSelected : (Mailbox*) item;
+ (void) writeArray : (Mailbox *) selectedItem;
+(void) focusMailAndQuit;

@end
