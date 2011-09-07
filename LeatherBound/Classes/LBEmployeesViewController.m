//
//  LBEmployeesViewController.m
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "LBEmployeesViewController.h"

#import "LBColoredHorizontalTabView.h"
#import "LBEmployee.h"
#import "LBEmployeeDetailViewController.h"
#import "LBEmployeeTableViewCell.h"

#pragma mark Internal Definitions

static NSArray *sTabColors = nil;
static CGFloat const LBNavigationItemTitleViewLabelFontSizePortraitOrientation = 25.0f;
static CGFloat const LBNavigationItemTitleViewLabelFontSizeLandscapeOrientation = 20.0f;

#pragma mark - Class Extension

@interface LBEmployeesViewController ()

@property (nonatomic, strong, readwrite) IBOutlet UITableView *employeesTableView;
@property (nonatomic, strong) LBEmployeeDetailViewController *employeeDetailViewController;
@property (nonatomic, strong) LBEmployeeObjectManager *employeeObjectManager;
@property (nonatomic, strong) LBEmployeeTableViewCell *selectedEmployeeTableViewCell;
@property (nonatomic, strong) NSIndexPath *selectedEmployeeTableViewCellIndexPath;

@end

@implementation LBEmployeesViewController

@synthesize employeesTableView;
@synthesize employeeDetailViewController;
@synthesize employeeObjectManager;
@synthesize selectedEmployeeTableViewCell;
@synthesize selectedEmployeeTableViewCellIndexPath;

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.employeesTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LBBackgroundEmployeesViewController"]];
	self.employeeDetailViewController = (LBEmployeeDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	self.employeeObjectManager = [[LBEmployeeObjectManager alloc] init];
	self.selectedEmployeeTableViewCell = nil;
	self.selectedEmployeeTableViewCellIndexPath = nil;
}

- (void)viewDidUnload
{
	[super viewDidUnload];

	self.employeesTableView = nil;

	self.parentViewController.view.clipsToBounds = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	UIImage *navigationBarBackgroundImage = [UIImage imageNamed:@"LBBackgroundEmployeesNavigationBar"];
	[self.navigationController.navigationBar setBackgroundImage:navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		if (self.selectedEmployeeTableViewCell == nil)
		{
			[self tableView:self.employeesTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		}
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[super prepareForSegue:segue sender:sender];

	LBEmployeeDetailViewController *destinationViewController = segue.destinationViewController;

	NSIndexPath *selectedIndexPath = [self.employeesTableView indexPathForCell:sender];
	destinationViewController.employee = [self.employeeObjectManager.employees objectAtIndex:(NSUInteger)selectedIndexPath.row];
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

#pragma mark - NSObject Methods

+ (void)initialize
{
	if (self == [LBEmployeesViewController class])
	{
		// Interestingly, kCGBlendModeHardLight, which is used in LBColoredHorizontalTabView, does not tolerate colors with full brightness. As a
		// result, brightness values are toned down to at most 99% to avoid blending artifacts.

		sTabColors = [NSArray arrayWithObjects:[UIColor colorWithHue:(243.0f / 359.0f) saturation:0.62f brightness:0.99f alpha:1.0f],		// Blue
											   [UIColor colorWithHue:(299.0f / 359.0f) saturation:1.0f brightness:0.74f alpha:1.0f],		// Purple
											   [UIColor colorWithHue:(357.0f / 359.0f) saturation:0.93f brightness:0.98f alpha:1.0f],		// Red
											   [UIColor colorWithHue:(117.0f / 359.0f) saturation:1.0f brightness:0.76f alpha:1.0f],		// Green
											   [UIColor colorWithHue:(60.0f / 359.0f) saturation:1.0f brightness:0.98f alpha:1.0f],			// Yellow
											   [UIColor colorWithHue:(29.0f / 359.0f) saturation:0.93f brightness:0.99f alpha:1.0f], nil];	// Orange
	}
}

#pragma mark - NSObject (UINibLoadingAdditions) Methods

- (void)awakeFromNib
{
	[super awakeFromNib];

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
	    self.contentSizeForViewInPopover = CGSizeMake(320.0f, 697.0f);
	}
}

#pragma mark - Protocol Implementations

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (NSInteger)[self.employeeObjectManager.employees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LBEmployee *employee = [self.employeeObjectManager.employees objectAtIndex:(NSUInteger)indexPath.row];
	LBEmployeeTableViewCell *employeeTableViewCell = [tableView dequeueReusableCellWithTableViewCellClass:[LBEmployeeTableViewCell class]];

	if ([indexPath isEqual:self.selectedEmployeeTableViewCellIndexPath])
	{
		employeeTableViewCell.accessoryType = UITableViewCellAccessoryNone;
	}
	else
	{
		employeeTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	UIColor *tabFillColor = [sTabColors objectAtIndex:((NSUInteger)indexPath.row % [sTabColors count])];

	employeeTableViewCell.coloredHorizontalTabView.tabColor = tabFillColor;
	employeeTableViewCell.thumbnailPhotoImageView.image = [self.employeeObjectManager thumbnailPhotoImageForEmployee:employee];
	employeeTableViewCell.nameLabel.text = employee.name;
	employeeTableViewCell.jobTitleLabel.text = employee.jobTitle;

	return employeeTableViewCell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	LBEmployeeTableViewCell *previouslySelectedEmployeeTableViewCell = self.selectedEmployeeTableViewCell;
	self.selectedEmployeeTableViewCell = (LBEmployeeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	self.selectedEmployeeTableViewCellIndexPath = indexPath;

	if (previouslySelectedEmployeeTableViewCell != nil)
	{
		CATransition *fadeTransition = [CATransition animation];

		[previouslySelectedEmployeeTableViewCell.layer addAnimation:fadeTransition forKey:kCATransition];
		[self.selectedEmployeeTableViewCell.layer addAnimation:fadeTransition forKey:kCATransition];

		previouslySelectedEmployeeTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.selectedEmployeeTableViewCell.accessoryType = UITableViewCellAccessoryNone;
	}
	else
	{
		self.selectedEmployeeTableViewCell.accessoryType = UITableViewCellAccessoryNone;
	}

	LBEmployeeDetailViewController *destinationViewController = self.employeeDetailViewController;
	destinationViewController.employee = [self.employeeObjectManager.employees objectAtIndex:(NSUInteger)indexPath.row];
	destinationViewController.coloredHorizontalTabView.tabColor = self.selectedEmployeeTableViewCell.coloredHorizontalTabView.tabColor;

	LBColoredHorizontalTabView *coloredHorizontalTabView = self.selectedEmployeeTableViewCell.coloredHorizontalTabView;
	CGRect coloredHorizontalTabViewFrame = [coloredHorizontalTabView convertRect:coloredHorizontalTabView.frame toView:self.view];

	destinationViewController.coloredHorizontalTabView.frameY = coloredHorizontalTabViewFrame.origin.y;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGRect rectForSelectedRow = [self.employeesTableView rectForRowAtIndexPath:self.selectedEmployeeTableViewCellIndexPath];
	CGFloat selectedEmployeeTableViewCellFrameY = (rectForSelectedRow.origin.y - self.employeesTableView.bounds.origin.y);

	LBEmployeeDetailViewController *destinationViewController = self.employeeDetailViewController;
	destinationViewController.coloredHorizontalTabView.frameY = selectedEmployeeTableViewCellFrameY;
}

@end