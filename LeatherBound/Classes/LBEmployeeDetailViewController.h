//
//  LBEmployeeDetailViewController.h
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

@class LBEmployee;
@class LBColoredHorizontalTabView;

@interface LBEmployeeDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong, readonly) IBOutlet LBColoredHorizontalTabView *coloredHorizontalTabView;
@property (nonatomic, strong, readonly) IBOutlet UIImageView *employeePhotoImageView;
@property (nonatomic, strong, readonly) IBOutlet UIView *employeeLabelContainerView;
@property (nonatomic, strong, readonly) IBOutlet UILabel *employeeJobTitleLabel;
@property (nonatomic, strong, readonly) IBOutlet UILabel *employeeYearsEmployedLabel;
@property (nonatomic, strong, readonly) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) LBEmployee *employee;

@end