//
//  LBEmployee.h
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

@interface LBEmployee : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, copy, readonly) NSString *photoImageName;
@property (nonatomic, copy, readonly) NSString *thumbnailPhotoImageName;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic) NSUInteger yearsEmployed;

+ (id)employeeWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface LBEmployeeObjectManager : NSObject

@property (nonatomic, copy, readonly) NSArray *employees;

- (UIImage *)photoImageForEmployee:(LBEmployee *)employee;
- (UIImage *)thumbnailPhotoImageForEmployee:(LBEmployee *)employee;

@end