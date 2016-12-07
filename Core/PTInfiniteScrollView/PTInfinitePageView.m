//
//  PTInfinitePageView.m
//  PTKit
//
//  Created by LeeHu on 14/12/13.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTInfinitePageView.h"
#import "PTTestCore.h"

@implementation PTInfinitePageView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 320, 480);
    if ((self = [super initWithFrame:frame])) {
    }
    return self;
}

- (instancetype)init
{
    if ((self = [super init])) {
    }
    return self;
}

static NSInteger i = 20;

+ (instancetype)randonPageView
{
    PTInfinitePageView *page = [[PTInfinitePageView alloc] initWithFrame:CGRectZero];
    page.backgroundColor = [PTTestCore colorForNumber:@(i++)];
    return page;
    
}

@end
