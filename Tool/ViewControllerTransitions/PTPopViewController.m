//
//  PTPopViewController.m
//  PTKit
//
//  Created by LeeHu on 8/19/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTPopViewController.h"
#import "PopAnimation.h"
#import "UINavigationBar+Extents.h"
#import "UIColor+Extents.h"
#import "PTPushViewController.h"

@interface PTPopViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) UIColor *startColor;


@end

@implementation PTPopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 60, 40);
    btn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btn];
    
    [btn setTitle:@"pop" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnOnClick
{
    PTPushViewController *vc = [[PTPushViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.startColor = self.navigationController.navigationBar.ex_colorLayer.backgroundColor;
    if ([self.startColor ex_isEqualToColor:[UIColor redColor]]) {
        return;
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
   
}

@end
