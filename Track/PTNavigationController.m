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
							 [UIColor whiteColor], UITextAttributeTextColor,
							 [UIColor clearColor], UITextAttributeTextShadowColor,
							 [UIFont systemFontOfSize:18], UITextAttributeFont, nil]];
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
	[super pushViewController:viewController animated:animated];
}

@end
