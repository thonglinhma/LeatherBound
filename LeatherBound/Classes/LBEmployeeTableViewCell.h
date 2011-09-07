//
//  LBEmployeeTableViewCell.h
//  LeatherBound
//
//  Created by Michael Potter on 9/2/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

@class LBColoredHorizontalTabView;

@interface LBEmployeeTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) IBOutlet LBColoredHorizontalTabView *coloredHorizontalTabView;
@property (nonatomic, strong, readonly) IBOutlet UIImageView *thumbnailPhotoImageView;
@property (nonatomic, strong, readonly) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong, readonly) IBOutlet UILabel *jobTitleLabel;

@end