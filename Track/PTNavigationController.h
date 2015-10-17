//
//  PTNavgationController.h
//  PTKit
//
//  Created by LeeHu on 15/2/6.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (leftBarButtonItem)

- (BOOL)topVCIsInModal;
- (UIBarButtonItem *)ex_leftBarButtonItem:(id)target action:(SEL)action;

@end

@interface PTNavigationController : UINavigationController

@end
