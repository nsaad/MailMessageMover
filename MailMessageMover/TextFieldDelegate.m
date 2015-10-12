//
//  TextFieldDelegate.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 08/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import "TextFieldDelegate.h"
#import "OutlineViewController.h"
#import "MailEngine.h"

@implementation TextFieldDelegate

@synthesize outlineView, outlineViewDelegate, theWindow, userInput;

MailEngine *myEngine;
static int TextFieldKVOContext = 0;

- (void) controlTextDidChange :(NSNotification *) sender {
    NSTextField *changedField = [sender object];
    
    //NSLog(@"in control text did change");
    
    NSString *text = [changedField stringValue];
    
    //NSLog(@"changed the label and creating the data now");

    [outlineViewDelegate refreshTheData:text];
    
    myEngine = [MailEngine sharedInstance];
    //NSLog(@"first item in accounts %@", [[myEngine getAllAccounts] objectAtIndex:0] );
    
}


- (void) awakeFromNib {
    //NSLog(@"in awake from nib");
    
    myEngine = [MailEngine sharedInstance];
    
    if (userInput) {
        [self.userInput addObserver:self
                         forKeyPath:@"stringValue"
                            options:NSKeyValueObservingOptionNew
                            context:&TextFieldKVOContext];
    }
    
    [theWindow makeFirstResponder:userInput];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //NSLog(@"in observe, object is %@", object);
    
    if (context != &TextFieldKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (object == self.userInput) {
        if ([keyPath isEqualToString:@"stringValue"]) {
            //NSLog(@"i'm aware the string got set: %@", [userInput stringValue]);
            [outlineViewDelegate refreshTheData:[userInput stringValue]];
        }
    }
}

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    
    //When enter is pressed in the NSTextField
    if (commandSelector == @selector(insertNewline:))
    {
        NSString *text = [[textView textStorage] string];
        //NSLog(@"insert new line text: %@", text);
        [outlineViewDelegate refreshTheData:text];
        [textView insertTab:self];
        
    }
    else if (commandSelector == @selector(insertTab:))
    {
        //NSLog(@"insert tab");
    }
    
    return result;
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL)canBecomeKeyView {
    return  YES;
}

@end
