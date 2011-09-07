//
//  LBEmployeesViewController.h
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

@interface LBEmployeesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) IBOutlet UITableView *employeesTableView;

@end