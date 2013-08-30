//
//  TestButtonDelegate.h
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestButtonDelegate : NSObject

@property (retain) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) IBOutlet NSTextField * lbStatus;

- (IBAction)testButtonClicked:(id)sender;

@end
