//
//  NSObject+LBAdditions.h
//  LeatherBound
//
//  Created by Michael Potter on 9/6/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

@interface NSObject (LBAdditions)

- (void)performBlockAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block;

@end