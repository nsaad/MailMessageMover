//
//  MailCountLabelDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailCountLabelDelegate : NSObject {
}

//Label that this delegate handles
@property (nonatomic, strong) IBOutlet NSTextField * lbMessageCount;

- (void) awakeFromNib;

@end
