//
//  PTNavgationController.m
//  PTKit
//
//  Created by LeeHu on 15/2/6.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTNavigationController.h"
#import "PTNavigationBar.h"
#import "UIBarButtonItem+Extents.h"

@implementation PTNavigationController

+ (void)initialize
{
	[[UINavigationBar appearance]
	 setTitleTextAttributes:[NSDictionary
							 dictionaryWithObjectsAndKeys:
							 [UIColor whiteColor], NSForegroundColorAttributeName,
							 [UIColor clearColor], NSShadowAttributeName,
							 [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
	[[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	

}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if ((self = [super initWithRootViewController:rootViewController])) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
	[super pushViewController:viewController animated:animated];
}

@end
