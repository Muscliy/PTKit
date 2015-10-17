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

@implementation UINavigationController (leftBarButtonItem)

- (UIBarButtonItem *)ex_leftBarButtonItem:(id)target action:(SEL)action
{
    if ([self topVCIsInModal]) {
        return [UIBarButtonItem ex_leftIconItemTarget:target
                                               action:action
                                           normalIcon:@"icon_Wclose"
                                        highlightIcon:@"icon_Wclose_in"];
    } else {
        if (self.viewControllers.count > 1) {
            return [UIBarButtonItem ex_leftIconItemTarget:target
                                                   action:action
                                               normalIcon:@"icon_back"
                                            highlightIcon:@"icon_back_in"];
        }
    }
    return nil;
}

- (BOOL)topVCIsInModal
{
    if (self.viewControllers.count <= 1 && self.presentingViewController) {
        return YES;
    }
    return NO;
}

@end

@implementation PTNavigationController

- (instancetype)init
{
    if ((self = [super initWithNavigationBarClass:[PTNavigationBar class] toolbarClass:nil])) {
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    
    
    

    if ((self = [super initWithNavigationBarClass:[PTNavigationBar class] toolbarClass:nil])) {
        self.viewControllers = @[ rootViewController ];
    }

    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
