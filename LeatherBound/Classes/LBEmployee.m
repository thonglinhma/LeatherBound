//
//  LBEmployee.m
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "LBEmployee.h"

#pragma mark LBEmployee Class

@implementation LBEmployee

@synthesize name;
@synthesize jobTitle;
@synthesize dateOfBirth;
@synthesize yearsEmployed;

#pragma mark - Property Accessors

- (NSString *)photoImageName
{
	return [NSString stringWithFormat:@"%@.gif", self.name];
}

- (NSString *)thumbnailPhotoImageName
{
	return [NSString stringWithFormat:@"%@ (Thumbnail).gif", self.name];
}

#pragma mark - LBEmployee Methods

+ (id)employeeWithDictionary:(NSDictionary *)dictionary
{
	return [[self alloc] initWithDictionary:dictionary];		// Should be autoreleased in a non-ARC environment
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];

	if (self != nil)
	{
		[self setValuesForKeysWithDictionary:dictionary];
	}

	return self;
}

@end

#pragma mark - LBEmployeeObjectManager Class

#pragma mark Internal Definitions

static NSString *const LBEmployeeImageBundlePathComponent = @"LBEmployeeImages.bundle";
static NSArray *sEmployees = nil;

@implementation LBEmployeeObjectManager

@synthesize employees;

#pragma mark - Property Accessors

- (NSArray *)employees
{
	return sEmployees;
}

#pragma mark - LBEmployeeObjectManager Methods

- (UIImage *)photoImageForEmployee:(LBEmployee *)employee
{
	return [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", LBEmployeeImageBundlePathComponent, employee.photoImageName]];
}

- (UIImage *)thumbnailPhotoImageForEmployee:(LBEmployee *)employee
{
	return [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", LBEmployeeImageBundlePathComponent, employee.thumbnailPhotoImageName]];
}

#pragma mark - NSObject Methods

+ (void)initialize
{
	if (self == [LBEmployeeObjectManager class])
	{
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LBEmployeeList" ofType:@"plist"];
		NSDictionary *rootPlistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
		NSArray *employeeDictionaries = [rootPlistDictionary objectForKey:@"Employees"];
		NSMutableArray *mutableEmployees = [NSMutableArray arrayWithCapacity:[employeeDictionaries count]];

		for (NSDictionary *employeeDictionary in employeeDictionaries)
		{
			LBEmployee *employee = [LBEmployee employeeWithDictionary:employeeDictionary];
			[mutableEmployees addObject:employee];
		}

		sEmployees = [mutableEmployees copy];
	}
}

@end