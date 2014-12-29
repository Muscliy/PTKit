//
//  ViewController.m
//  PTKit
//
//  Created by LeeHu on 14/11/24.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "ViewController.h"
#import "PTInfiniteScrollView.h"
#import "PTSystemInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    PTInfiniteScrollView *scrollView = [[PTInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    scrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:scrollView];
    
    NSString *macAddress = macaddress();
    NSLog(@"%@",macAddress);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
