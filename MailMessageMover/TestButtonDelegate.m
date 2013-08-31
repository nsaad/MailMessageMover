//
//  TestButtonDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 21/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "TestButtonDelegate.h"
#import "OutlineViewController.h"
#import "MailEngine.h"

@implementation TestButtonDelegate

@synthesize outlineView;
@synthesize lbStatus;

- (IBAction)testButtonClicked:(id)sender {
    NSLog(@"Test button clicked");
    
/*    NSString *path = [[NSBundle mainBundle] pathForResource:@"getMailMessageInfo" ofType:@"scpt"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    if (script != nil) {
        NSAppleEventDescriptor *result = [script executeAndReturnError:nil];
        NSString *scriptReturn = [result stringValue];
        NSLog(@"Found utxt string: %@",scriptReturn);
        
        [lbStatus setStringValue:scriptReturn];
    }
    */
    
    MailEngine *myEngine = [MailEngine sharedInstance];
    
    
        
        /*
        for (NSInteger idx = 1; idx <= num; ++idx) {
            NSAppleEventDescriptor *item = [result descriptorAtIndex:idx];
            NSString *str = [item stringValue];
            NSLog(@"str == %@", str);
            
            [myEngine addToAccounts:str];
            
            }
         */

    //[outlineView reloadData];
}

@end
