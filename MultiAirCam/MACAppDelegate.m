//
//  MACAppDelegate.m
//  MultiAirCam
//
//  Created by Martin Gratzer on 09.12.12.
//  Copyright (c) 2012 Martin Gratzer. All rights reserved.
//

#import "MACAppDelegate.h"
#import "MACCameraListViewController.h"
#import "MACCameraViewController.h"

@implementation MACAppDelegate
//............................................................................
#pragma mark -
#pragma mark Memory Management
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Public
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Override
//............................................................................

//............................................................................
#pragma mark -
#pragma mark Delegates
//............................................................................

#pragma mark UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.idleTimerDisabled = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [MACViewController iPad] ? [MACCameraListViewController controller] : [MACCameraViewController controller];
    [self.window makeKeyAndVisible];
    return YES;
}

//............................................................................
#pragma mark -
#pragma mark Private
//............................................................................


@end
