//
//  PTViewController.m
//  PTKit
//
//  Created by LeeHu on 11/6/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTViewController.h"
#import "UIBarButtonItem+Extents.h"

@interface PTViewController ()

@end

@implementation PTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UI

- (void)setTitle:(NSString *)title
{
    [_navigationBar setTitle:title];
}

- (void)addNavigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[PTNavigationBar alloc]
             initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopBarHeight + kPTStatusBarHeight)
            needBlurEffect:NO];
        _navigationBar.backgroundColor = COLOR_TITLEBAR_GREEN;
        _navigationBar.layer.zPosition = 100;
		[self.view addSubview:_navigationBar];
    }
}

@end
