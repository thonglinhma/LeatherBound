//
//  NSObject+LBAdditions.m
//  LeatherBound
//
//  Created by Michael Potter on 9/6/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "NSObject+LBAdditions.h"

@implementation NSObject (LBAdditions)

#pragma mark - NSObject (LBAdditions) Methods

- (void)performBlockAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * (NSTimeInterval)NSEC_PER_SEC));

	dispatch_after(popTime, dispatch_get_current_queue(), block);
}

@end