//
//  UIViewController+POPHUD.m
//  PTKit
//
//  Created by LeeHu on 5/6/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "UIViewController+POPHUD.h"
#import <objc/runtime.h>

@implementation UIViewController (POPHUD)

//----------------------------------------------------

#pragma mark - 扩展属性设置

//----------------------------------------------------

@dynamic HUD;
- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, @"hud");
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, @"hud", HUD, OBJC_ASSOCIATION_RETAIN);
}

@dynamic loading;
- (BOOL)loading
{
    return [objc_getAssociatedObject(self, @"loading") longLongValue];
}

- (void)setLoading:(BOOL)loading
{
    objc_setAssociatedObject(self, @"loading", @(loading), OBJC_ASSOCIATION_RETAIN);
}

//----------------------------------------------------

#pragma mark - 方法
//----------------------------------------------------

//展示状态
//----------------------------------------------------
- (void)showNetWorkErrorHUD
{
    // TODO:
}

- (void)showNetWorkErrorHUD:(UIView *)customView
{
    [self showNetWorkErrorHUD:customView text:nil];
}

- (void)showNetWorkErrorHUD:(UIView *)customView text:(NSString *)text
{
    [self showNetWorkErrorHUD:customView text:text detail:nil];
}

- (void)showNetWorkErrorHUD:(UIView *)customView text:(NSString *)text detail:(NSString *)detail
{
    [self showNetWorkErrorHUD:customView text:text detail:detail closeDelay:2.0];
}

- (void)showNetWorkErrorHUD:(UIView *)customView
                       text:(NSString *)text
                     detail:(NSString *)detail
                 closeDelay:(NSTimeInterval)time
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view.window addSubview:self.HUD];
    
    self.HUD.customView = customView;
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    self.HUD.delegate = self;
    self.HUD.labelText = @"网络错误";
    
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:time];
}

//展示加载
//----------------------------------------------------

- (void)showLoadingHUD
{
    [self showLoadingHUDInView:@"加载中" view:self.view.window];
}

- (void)showLoadingHUDInView:(NSString *)text view:(UIView *)view
{
    [self showLoadingHUDInView:text detail:nil view:view];
}

- (void)showLoadingHUDInView:(NSString *)text detail:(NSString *)detail view:(UIView *)view
{
    self.loading = FALSE;
    if (self.HUD) {
        [self hideHUD];
    }
    self.HUD = [[MBProgressHUD alloc] initWithView:view];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.bounds = CGRectMake(0, 0, 35, 35);
    indicatorView.hidesWhenStopped = YES;
    [indicatorView startAnimating];
    
    self.HUD.color = [UIColor clearColor];
    
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.customView = indicatorView;
    // HUD.dimBackground = YES;
    
    [view addSubview:self.HUD];
    if (text)
        self.HUD.labelText = text;
    
    self.HUD.removeFromSuperViewOnHide = YES;
    
    [self.HUD show:YES];
}

//延迟隐藏
//----------------------------------------------------
- (void)delayHideHUD
{
    [self hideHUDAfter:1.0];
}

- (void)hideHUDAfter:(NSTimeInterval)time
{
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:time];
}

//隐藏
//----------------------------------------------------
- (void)hideHUD
{
    self.loading = NO;
    [self.HUD hide:YES];
}

//----------------------------------------------------

#pragma mark - MBProgressHUDDelegate

//----------------------------------------------------

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

@end
