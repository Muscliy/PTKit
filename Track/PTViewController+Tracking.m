//
//  PTViewController+Tracking.m
//  PTKit
//
//  Created by LeeHu on 11/6/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTViewController+Tracking.h"
#import "NSObject+Tracking.h"

@implementation PTViewController (Tracking)

+ (void)load
{
	if (PTOS_IOS7) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			[self swizzleMethod:@selector(viewWillAppear:)
					 withMethod:@selector(trackViewWillAppear:)];
		});
	}
}

- (void)trackViewWillAppear:(BOOL)animated
{
	[self trackViewWillAppear:animated];
	[self addNavigationBar];
}

@end
