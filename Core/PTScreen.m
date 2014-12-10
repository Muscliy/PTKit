//
//  PTScreen.m
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTScreen.h"

@implementation PTScreen

+ (void)initialize
{
	if (self == [PTScreen class]) {
		[self scale];
		[self size];
	}
}

+ (CGFloat)scale
{
	static CGFloat scale = -1;
	if (scale < 0) {
		scale = [UIScreen mainScreen].scale;
	}
	return scale;
}

+ (CGSize)size
{
	static CGSize size = {-1, -1};
	if (size.width < 0) {
		size = [UIScreen mainScreen].bounds.size;
	}
	return size;
}

+ (CGFloat)screenHeight{
	static CGFloat height = -1;blackhatWithIterations:
	if (height < 0) {
		height = [UIScreen mainScreen].bounds.size.height;
	}
	return height;
}

+ (CGSize)sizeInOrientation
{
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
	CGRect statusBarRect = [UIApplication sharedApplication].statusBarFrame;
	CGFloat statusBarHeight = statusBarRect.size.height;
	
	if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
		CGFloat temp = screenSize.height;
		screenSize.height = screenSize.width;
		screenSize.width = temp;
		
		statusBarHeight = statusBarRect.size.width;
	}
	
	if ([UIApplication sharedApplication].statusBarHidden == NO) {
		screenSize.height -= statusBarHeight;
	}
	
	return screenSize;
}


@end
