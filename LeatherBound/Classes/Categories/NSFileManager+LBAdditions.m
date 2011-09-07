//
//  NSFileManager+LBAdditions.m
//  LeatherBound
//
//  Created by Michael Potter on 9/4/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "NSFileManager+LBAdditions.h"

@implementation NSFileManager (LBAdditions)

#pragma mark - Property Accessors

- (NSURL *)userDocumentsDirectoryURL
{
	return [[self URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - NSFileManager (LBAdditions) Methods

- (BOOL)fileExistsAtURL:(NSURL *)url
{
	return [self fileExistsAtPath:[url path]];
}

@end