//
//  TestButtonDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelButtonDelegate : NSObject

@property (nonatomic, strong) IBOutlet NSButton * cancelButton;

- (IBAction) cancelButtonClicked:(id) sender;

@end
