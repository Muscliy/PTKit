//
//  PTUIMathUtilities.m
//  xmLife
//
//  Created by LeeHu on 14/11/11.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTUIMathUtilities.h"
#import "PTRectMacro.h"
#import "PTBoxGroup.h"


CGFloat PTRoundPixelValueForScale(CGFloat f, CGFloat scale)
{
	// Round to the nearest device pixel (.5 on retina)
	return roundf(f * scale) / scale;
}

CGFloat PTRoundPixelValue(CGFloat f)
{
	return PTRoundPixelValueForScale(f, [PTScreen scale]);
}

NSUInteger PTRoundPixIntValue(CGFloat f)
{
	return roundf(f);
}

/**
 *  计算动态label的时候，高度优化必须使用这个函数，否者优化值比计算值小那么有部分文字是不能显示的
 *
 *  @param f
 *
 *  @return
 */
NSUInteger PTRoundLabelPixelValue(CGFloat f)
{
	return f > PTRoundPixIntValue(f) ? PTRoundPixIntValue(f) + 1 : PTRoundPixIntValue(f);
}

CGFloat PTRoundPixelSacle640Value(CGFloat f)
{
	return PTRoundPixelValue(f * [PTBoxGroup contentScale640]);
}

CGFloat PTRoundPixelSacle320Value(CGFloat f)
{
	return PTRoundPixelValue(f*[PTBoxGroup contentScale320]);
}

CGFloat PTRatio4InchWithCurrentPhoneSize()
{
	return SCREEN_WIDTH / k4InchScreenWith;
}
