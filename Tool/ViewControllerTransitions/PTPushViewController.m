//
//  PTPushViewController.m
//  PTKit
//
//  Created by LeeHu on 8/19/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTPushViewController.h"
#import "PTPopViewController.h"
#import "NavigationControllerDelegate.h"
#import "UINavigationBar+Extents.h"
#import "PTSearchDisplayController.h"

@interface PTPushViewController ()

@property (nonatomic, strong) NavigationControllerDelegate *navDelegate;
@property (nonatomic, strong) UIColor *startColor;

@end

@implementation PTPushViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 60, 40);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnOnClick
{
    PTSearchDisplayController *vc = [[PTSearchDisplayController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
