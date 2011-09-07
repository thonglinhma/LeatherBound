//
//  LBEmployeeDetailViewController.m
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "LBEmployeeDetailViewController.h"

#import "LBColoredHorizontalTabView.h"
#import "LBEmployee.h"

#pragma mark Internal Definitions

static CGSize const LBContentScrollViewContentSizePortraitiPhone = {320.0f, 417.0f};
static CGSize const LBContentScrollViewContentSizeLandscapeiPhone = {480.0f, 417.0f};
static CGSize const LBContentScrollViewContentSizePortraitiPad = {768.0f, 961.0f};
static CGSize const LBContentScrollViewContentSizeLandscapeiPad = {703.0f, 705.0f};

#pragma mark - Class Extension

@interface LBEmployeeDetailViewController ()

@property (nonatomic, strong, readwrite) IBOutlet LBColoredHorizontalTabView *coloredHorizontalTabView;
@property (nonatomic, strong, readwrite) IBOutlet UIImageView *employeePhotoImageView;
@property (nonatomic, strong, readwrite) IBOutlet UIView *employeeLabelContainerView;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *employeeJobTitleLabel;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *employeeYearsEmployedLabel;
@property (nonatomic, strong, readwrite) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@property (nonatomic, strong) LBEmployeeObjectManager *employeeObjectManager;

- (void)configureViewForActiveEmployee;
- (void)repositionSubviewsForOrientationChange;
- (void)setContentScrollViewContentSizeForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)setClipsToBounds:(BOOL)clipsToBounds forSplitViewControllerViewHierarchy:(UIView *)splitViewControllerView;
- (void)animateColoredHorizontalTabViewVisibility:(BOOL)visible;

@end

@implementation LBEmployeeDetailViewController

@synthesize coloredHorizontalTabView;
@synthesize employeePhotoImageView;
@synthesize employeeLabelContainerView;
@synthesize employeeJobTitleLabel;
@synthesize employeeYearsEmployedLabel;
@synthesize contentScrollView;
@synthesize employee;
@synthesize masterPopoverController;
@synthesize employeeObjectManager;

#pragma mark - Property Accessors

- (void)setEmployee:(LBEmployee *)newEmployee
{
    if (self.employee != newEmployee)
	{
		UIViewAnimationOptions animationOptions = 0;

		if ([self.employeeObjectManager.employees indexOfObject:newEmployee] > [self.employeeObjectManager.employees indexOfObject:employee])
		{
			animationOptions = UIViewAnimationOptionTransitionCurlUp;
		}
		else
		{
			animationOptions = UIViewAnimationOptionTransitionCurlDown;
		}

        employee = newEmployee;

		if ([self isViewLoaded])
		{
			[self configureViewForActiveEmployee];

			[UIView transitionWithView:self.view duration:0.5 options:animationOptions animations:nil completion:nil];
		}
    }

    if (self.masterPopoverController != nil)
	{
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (LBEmployeeObjectManager *)employeeObjectManager
{
	if (employeeObjectManager == nil)
	{
		employeeObjectManager = [[LBEmployeeObjectManager alloc] init];
	}

	return employeeObjectManager;
}

#pragma mark - LBEmployeeDetailViewController Methods (Private)

- (void)configureViewForActiveEmployee
{
	if (self.employee != nil)
	{
		self.title = self.employee.name;
		self.employeePhotoImageView.image = [self.employeeObjectManager photoImageForEmployee:self.employee];
		self.employeeJobTitleLabel.text = self.employee.jobTitle;
		self.employeeYearsEmployedLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.employee.yearsEmployed];
	}
}

- (void)repositionSubviewsForOrientationChange
{
	self.contentScrollView.frame = self.view.frame;
	self.employeeLabelContainerView.frameY = (self.employeePhotoImageView.frameMaxY + 8.0f);
}

- (void)setContentScrollViewContentSizeForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	CGSize contentScrollViewContentSize = self.contentScrollView.contentSize;

	if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
	{
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		{
			contentScrollViewContentSize = LBContentScrollViewContentSizePortraitiPhone;
		}
		else
		{
			contentScrollViewContentSize = LBContentScrollViewContentSizePortraitiPad;
		}
	}
	else
	{
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		{
			contentScrollViewContentSize = LBContentScrollViewContentSizeLandscapeiPhone;
		}
		else
		{
			contentScrollViewContentSize = LBContentScrollViewContentSizeLandscapeiPad;
		}
	}

	self.contentScrollView.contentSize = contentScrollViewContentSize;
}

- (void)setClipsToBounds:(BOOL)clipsToBounds forSplitViewControllerViewHierarchy:(UIView *)splitViewControllerView
{
	// In order to achieve a seamless image between the master and detail split views for the currently selected employee tab, certain views in the
	// split view controller's view hierarchy must be set to not clip their subviews to their bounds. This method is a hack as it relies on exploring
	// the undocumented view hierarchy of a UIKit container view controller class. Nevertheless, its use is merely for visual effect and should have
	// no effect on the underlying mechanics of UISplitViewController.

	for (UIView *subview in splitViewControllerView.subviews)
	{
		Class layoutContainerViewClass = NSClassFromString(@"UILayoutContainerView");
		Class navigationTransitionViewClass = NSClassFromString(@"UINavigationTransitionView");

		if ([subview isKindOfClass:layoutContainerViewClass] || [subview isKindOfClass:navigationTransitionViewClass])
		{
			subview.clipsToBounds = clipsToBounds;

			if ([subview.subviews count] > 0)
			{
				[self setClipsToBounds:clipsToBounds forSplitViewControllerViewHierarchy:subview];
			}
		}
	}
}

- (void)animateColoredHorizontalTabViewVisibility:(BOOL)visible
{
	CATransition *pushTransition = [CATransition animation];
	pushTransition.type = kCATransitionPush;
	pushTransition.subtype = (visible ? kCATransitionFromLeft : kCATransitionFromRight);
	pushTransition.duration = 0.3;

	[self.coloredHorizontalTabView.layer addAnimation:pushTransition forKey:kCATransition];

	self.coloredHorizontalTabView.hidden = !visible;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.contentScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LBBackgroundEmployeeDetail"]];
	self.coloredHorizontalTabView.type = LBColoredHorizontalTabViewTypeArrow;
	self.employeePhotoImageView.layer.magnificationFilter = kCAFilterNearest;	// Prevent resampling during sprite upscaling

	[self configureViewForActiveEmployee];

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		[self setClipsToBounds:NO forSplitViewControllerViewHierarchy:self.splitViewController.view];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	self.coloredHorizontalTabView = nil;
	self.employeePhotoImageView = nil;
	self.employeeLabelContainerView = nil;
	self.contentScrollView = nil;
	self.employeeJobTitleLabel = nil;
	self.employeeYearsEmployedLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self setContentScrollViewContentSizeForInterfaceOrientation:self.interfaceOrientation];
	[self repositionSubviewsForOrientationChange];

	UIImage *navigationBarBackgroundImage = [UIImage imageNamed:@"LBBackgroundEmployeeDetailNavigationBar"];
	navigationBarBackgroundImage = [navigationBarBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 130.0f, 0.0f, 130.0f)];
	[self.navigationController.navigationBar setBackgroundImage:navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];

	if (self.employee == nil)
	{
		self.employee = [self.employeeObjectManager.employees objectAtIndex:0];
		self.coloredHorizontalTabView.tabColor = [UIColor colorWithHue:(243.0f / 359.0f) saturation:0.62f brightness:0.99f alpha:1.0f];

		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
		{
			self.coloredHorizontalTabView.hidden = YES;
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL shouldAutorotate = YES;

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
	    shouldAutorotate = (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	}

	return shouldAutorotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	[self setContentScrollViewContentSizeForInterfaceOrientation:interfaceOrientation];
	[self repositionSubviewsForOrientationChange];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - Protocol Implementations

#pragma mark - UISplitViewControllerDelegate Methods

- (void)splitViewController:(UISplitViewController *)splitViewController willHideViewController:(UIViewController *)viewController
	withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
	[self animateColoredHorizontalTabViewVisibility:NO];

    barButtonItem.title = @"Employees";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitViewController willShowViewController:(UIViewController *)viewController
	invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	[self animateColoredHorizontalTabViewVisibility:YES];

    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    self.masterPopoverController = nil;
}

@end