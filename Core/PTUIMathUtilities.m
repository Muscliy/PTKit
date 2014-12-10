//
//  PTUIMathUtilities.m
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTUIMathUtilities.h"

CGFloat PTRoundPixelValueForScale(CGFloat f, CGFloat scale) {
	// Round to the nearest device pixel (.5 on retina)
	return roundf(f * scale) / scale;
}

CGFloat PTRoundPixelValue(CGFloat f) {
	return PTRoundPixelValueForScale(f, [PTScreen scale]);
}
