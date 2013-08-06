//
//  main.m
//  MailMessageMover
//
//  Created by Nabeel Saad on 06/08/2013.
//  Copyright (c) 2013 Nabeel Saad. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, (const char **)argv);
}
