//
//  LBAppDelegate.m
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "LBAppDelegate.h"

@implementation LBAppDelegate

@synthesize window;

#pragma mark - Protocol Implementations

#pragma mark - UIApplicationDelegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
	    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
	    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
	    splitViewController.delegate = (id<UISplitViewControllerDelegate>)navigationController.topViewController;
	}

    return YES;
}

@end