//
//  LBColoredHorizontalTabView.m
//  LeatherBound
//
//  Created by Michael Potter on 9/1/11.
//  Copyright (c) 2011 Michael Potter. All rights reserved.
//

#import "LBColoredHorizontalTabView.h"

#pragma mark Internal Definitions

static NSString *const LBPrerenderedTabImagesDirectoryName = @"LBPrerenderedTabImages";

#pragma mark - Class Extension

@interface LBColoredHorizontalTabView ()

@property (nonatomic, strong) UIImageView *tabImageView;
@property (nonatomic, copy, readonly) NSString *typeString;

- (BOOL)prerenderedTabExistsForColor:(UIColor *)color;
- (NSURL *)prerenderedTabFileURLForColor:(UIColor *)color;
- (void)renderTabImageToFileForColor:(UIColor *)color;

@end

@implementation LBColoredHorizontalTabView

@synthesize tabColor;
@synthesize type;
@synthesize tabImageView;

#pragma mark - Property Accessors

- (void)setTabColor:(UIColor *)newTabColor
{
	tabColor = newTabColor;

	if (! [self prerenderedTabExistsForColor:self.tabColor])
	{
		[self renderTabImageToFileForColor:self.tabColor];
	}

	CGFloat scale = [[UIScreen mainScreen] scale];

	NSURL *prerenderedTabFileURL = [self prerenderedTabFileURLForColor:self.tabColor];
	NSData *prerenderedTabImageData = [NSData dataWithContentsOfURL:prerenderedTabFileURL];
	UIImage *prerenderedTabImage = [UIImage imageWithData:prerenderedTabImageData];
	prerenderedTabImage = [UIImage imageWithCGImage:prerenderedTabImage.CGImage scale:scale orientation:prerenderedTabImage.imageOrientation];
	prerenderedTabImage = [prerenderedTabImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 319.0f, 0.0f, 0.0f)];

	self.tabImageView.image = prerenderedTabImage;
}

- (void)setType:(LBColoredHorizontalTabViewType)newType
{
	type = newType;

	if (type == LBColoredHorizontalTabViewTypeArrow)
	{
		self.tabImageView.contentMode = UIViewContentModeRight;
	}
}

- (NSString *)typeString
{
	NSString *stringForType = nil;

	if (self.type == LBColoredHorizontalTabViewTypeNormal)
	{
		stringForType = @"Normal";
	}
	else if (self.type == LBColoredHorizontalTabViewTypeArrow)
	{
		stringForType = @"Arrow";
	}

	return stringForType;
}

#pragma mark - LBColoredHorizontalTabView Methods (Private)

- (BOOL)prerenderedTabExistsForColor:(UIColor *)color
{
	BOOL prerenderedTabExists = NO;

	NSURL *prerenderedTabFileURL = [self prerenderedTabFileURLForColor:color];

	if (prerenderedTabFileURL != nil)
	{
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		prerenderedTabExists = [fileManager fileExistsAtURL:prerenderedTabFileURL];
	}

	return prerenderedTabExists;
}

- (NSURL *)prerenderedTabFileURLForColor:(UIColor *)color
{
	NSString *prerenderedTabFilename = nil;
	NSURL *prerenderedTabFileURL = nil;

	CGFloat colorHue = 0.0f;
	CGFloat colorSaturation = 0.0f;
	CGFloat colorBrightness = 0.0f;
	CGFloat colorAlpha = 0.0f;

	BOOL didRetrieveColorComponents = [color getHue:&colorHue saturation:&colorSaturation brightness:&colorBrightness alpha:&colorAlpha];

	if (didRetrieveColorComponents)
	{
		prerenderedTabFilename = [NSString stringWithFormat:@"%@_%f_%f_%f_%f.png", self.typeString, colorHue, colorSaturation, colorBrightness,
			colorAlpha];

		NSFileManager *fileManager = [[NSFileManager alloc] init];
		prerenderedTabFileURL = [fileManager.userDocumentsDirectoryURL URLByAppendingPathComponent:LBPrerenderedTabImagesDirectoryName];
		prerenderedTabFileURL = [prerenderedTabFileURL URLByAppendingPathComponent:prerenderedTabFilename];
	}

	return prerenderedTabFileURL;
}

- (void)renderTabImageToFileForColor:(UIColor *)color
{
	CGRect rect = self.bounds;

	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextTranslateCTM(context, 0.0f, rect.size.height);
	CGContextScaleCTM(context, 1.0f, -1.0f);

	CGContextSaveGState(context);

	NSString *imageBaseName = [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), self.typeString];
	NSString *maskImageName = [NSString stringWithFormat:@"%@%@", imageBaseName, @"Mask"];

	UIImage *maskImage = [UIImage imageNamed:maskImageName];
	CGContextClipToMask(context, rect, maskImage.CGImage);

	CGContextSetFillColorWithColor(context, self.tabColor.CGColor);
	CGContextFillRect(context, rect);

	CGContextRestoreGState(context);

	CGContextSetBlendMode(context, kCGBlendModeHardLight);

	NSString *baseImageName = [NSString stringWithFormat:@"%@%@", imageBaseName, @"Base"];

	UIImage *baseImage = [UIImage imageNamed:baseImageName];
	CGContextDrawImage(context, rect, baseImage.CGImage);

	UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
	NSData *renderedImageData = UIImagePNGRepresentation(renderedImage);

	UIGraphicsEndImageContext();

	NSURL *renderedTabFileURL = [self prerenderedTabFileURLForColor:self.tabColor];

	[renderedImageData writeToURL:renderedTabFileURL atomically:YES];
}

#pragma mark - NSObject Methods

+ (void)initialize
{
	if (self == [LBColoredHorizontalTabView class])
	{
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		NSURL *prerenderedTabImagesDirectoryURL = [fileManager.userDocumentsDirectoryURL
			URLByAppendingPathComponent:LBPrerenderedTabImagesDirectoryName];

		[fileManager removeItemAtURL:prerenderedTabImagesDirectoryURL error:nil];
		[fileManager createDirectoryAtURL:prerenderedTabImagesDirectoryURL withIntermediateDirectories:NO attributes:nil error:nil];
	}
}

#pragma mark - Protocol Implementations

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];

	if (self != nil)
	{
		self.type = LBColoredHorizontalTabViewTypeNormal;

		self.tabImageView = [[UIImageView alloc] initWithFrame:self.frame];
		self.tabImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		[self addSubview:self.tabImageView];
	}

	return self;
}

@end