//
//  UIView+Frame.m
//  PTKit
//
//  Created by LeeHu on 7/1/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)ex_top
{
	return self.frame.origin.y;
}

- (void)setEx_top:(CGFloat)ex_top
{
	CGRect frame = self.frame;
	frame.origin.y = ex_top;
	self.frame = frame;
}

- (CGFloat)ex_right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setEx_right:(CGFloat)ex_right
{
	CGRect frame = self.frame;
	frame.origin.x = ex_right - self.frame.size.width;
	self.frame = frame;
}

- (CGFloat)ex_bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setEx_bottom:(CGFloat)ex_bottom
{
	CGRect frame = self.frame;
	frame.origin.y = ex_bottom - self.frame.size.height;
	self.frame = frame;
}

- (CGFloat)ex_left
{
	return self.frame.origin.x;
}

- (void)setEx_left:(CGFloat)ex_left
{
	CGRect frame = self.frame;
	frame.origin.x = ex_left;
	self.frame = frame;
}

- (CGFloat)ex_width
{
	return self.frame.size.width;
}

- (void)setEx_width:(CGFloat)ex_width
{
	CGRect frame = self.frame;
	frame.size.width = ex_width;
	self.frame = frame;
}

- (CGFloat)ex_height
{
	return self.frame.size.height;
}

- (void)setEx_height:(CGFloat)ex_height
{
	CGRect frame = self.frame;
	frame.size.height = ex_height;
	self.frame = frame;
}

#pragma mark - Shortcuts for frame properties

- (CGPoint)ex_origin
{
	return self.frame.origin;
}

- (void)setEx_origin:(CGPoint)ex_origin
{
	CGRect frame = self.frame;
	frame.origin = ex_origin;
	self.frame = frame;
}

- (CGSize)ex_size
{
	return self.frame.size;
}

- (void)setEx_size:(CGSize)ex_size
{
	CGRect frame = self.frame;
	frame.size = ex_size;
	self.frame = frame;
}
#pragma mark - Shortcuts for positions

- (CGFloat)ex_centerX
{
	return self.center.x;
}

- (void)setEx_centerX:(CGFloat)ex_centerX
{
	self.center = CGPointMake(ex_centerX, self.center.y);
}

- (CGFloat)ex_centerY
{
	return self.center.y;
}

- (void)setEx_centerY:(CGFloat)ex_centerY
{
	self.center = CGPointMake(self.center.x, ex_centerY);
}

@end
