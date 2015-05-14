//
//  PTButtonBarPagerTabStripExampleViewController.m
//  PTKit
//
//  Created by LeeHu on 5/7/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTButtonBarPagerTabStripExampleViewController.h"
#import "PTTagListViewController.h"
#import "PTSegmentedControlViewController.h"

@implementation PTButtonBarPagerTabStripExampleViewController
{
    BOOL _isReload;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isProgressiveIndicator = NO;
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor orangeColor]];
}

- (NSArray *)childViewControllersForPagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController
{
    PTTagListViewController *child_1 = [[PTTagListViewController alloc] initWithNibName:nil bundle:nil];
    PTSegmentedControlViewController *child_2 = [[PTSegmentedControlViewController alloc] initWithNibName:nil bundle:nil];
    PTTagListViewController *child_3 = [[PTTagListViewController alloc] initWithNibName:nil bundle:nil];
    PTSegmentedControlViewController *child_4 = [[PTSegmentedControlViewController alloc] initWithNibName:nil bundle:nil];
    PTTagListViewController *child_5 = [[PTTagListViewController alloc] initWithNibName:nil bundle:nil];
    PTSegmentedControlViewController *child_6 = [[PTSegmentedControlViewController alloc] initWithNibName:nil bundle:nil];
    return @[child_1, child_2, child_3, child_4, child_5, child_6];
}

- (void)reloadPagerTabStripView
{
    _isReload = YES;
    self.isProgressiveIndicator = (rand() % 2 == 0);
    self.isElasticIndicatorLimit = (rand() % 2 == 0);
    [super reloadPagerTabStripView];
}

@end
