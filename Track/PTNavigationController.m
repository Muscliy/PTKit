//
//  PTNavgationController.m
//  PTKit
//
//  Created by LeeHu on 15/2/6.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTNavigationController.h"
#import "PTNavigationBar.h"

@implementation PTNavigationController

- (instancetype)init {
    if((self = [super initWithNavigationBarClass:[PTNavigationBar class] toolbarClass:nil])) {
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    if((self = [super initWithNavigationBarClass:[PTNavigationBar class] toolbarClass:nil])) {
        self.viewControllers = @[rootViewController];
    }
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
