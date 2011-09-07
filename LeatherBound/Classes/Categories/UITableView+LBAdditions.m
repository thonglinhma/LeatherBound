//
//  UITableView+LBAdditions.m
//  LeatherBound
//
//  Created by Michael Potter on 9/2/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "UITableView+LBAdditions.h"

@implementation UITableView (LBAdditions)

#pragma mark - UITableView (LBAdditions) Methods

- (id)dequeueReusableCellWithTableViewCellClass:(Class)tableViewCellClass
{
	return [self dequeueReusableCellWithIdentifier:NSStringFromClass(tableViewCellClass)];
}

@end