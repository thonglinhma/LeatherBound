//
//  LBShadowedNavigationBar.m
//  LeatherBound
//
//  Created by Michael Potter on 9/3/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "LBShadowedNavigationBar.h"

@implementation LBShadowedNavigationBar

#pragma mark - UIView Methods

- (void)willMoveToWindow:(UIWindow *)window
{
	[super willMoveToWindow:window];

	self.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
	self.layer.shadowOpacity = 0.75f;
	self.clipsToBounds = NO;

	self.layer.shouldRasterize = YES;
}

@end