//
//  LBColoredHorizontalTabView.h
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

typedef enum LBColoredHorizontalTabViewType
{
	LBColoredHorizontalTabViewTypeNormal,			// Default
	LBColoredHorizontalTabViewTypeArrow
}
LBColoredHorizontalTabViewType;

@interface LBColoredHorizontalTabView : UIView

@property (nonatomic, strong) UIColor *tabColor;
@property (nonatomic) LBColoredHorizontalTabViewType type;

@end