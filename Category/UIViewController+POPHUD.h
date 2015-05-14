//
//  UIViewController+POPHUD.h
//  PTKit
//
//  Created by LeeHu on 5/6/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UIViewController (POPHUD) <MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, assign) BOOL loading;

- (void)hideHUD;
- (void)hideHUDAfter:(NSTimeInterval)time;

- (void)showNetWorkErrorHUD;
- (void)showNetWorkErrorHUD:(UIView *)customView;
- (void)showNetWorkErrorHUD:(UIView *)customView text:(NSString *)text;
- (void)showNetWorkErrorHUD:(UIView *)customView text:(NSString *)text detail:(NSString *)detail;
- (void)showNetWorkErrorHUD:(UIView *)customView
                       text:(NSString *)text
                     detail:(NSString *)detail
                 closeDelay:(NSTimeInterval)time;

- (void)showLoadingHUD;
- (void)showLoadingHUDInView:(NSString *)text view:(UIView *)view;
- (void)showLoadingHUDInView:(NSString *)text detail:(NSString *)detail view:(UIView *)view;

@end
