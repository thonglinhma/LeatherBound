//
//  NSFileManager+LBAdditions.h
//  LeatherBound
//
//  Created by Michael Potter on 9/4/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

@interface NSFileManager (LBAdditions)

@property (nonatomic, copy, readonly) NSURL *userDocumentsDirectoryURL;

- (BOOL)fileExistsAtURL:(NSURL *)url;

@end