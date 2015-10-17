//
//  PTBaseViewCotroller.h
//  PTKit
//
//  Created by LeeHu on 14/12/1.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, PTStatusBarAnimationAble) {
    PTStatusBarAnimationNone = 0,
    PTStatusBarAnimationShow = 1 << 0,
    PTStatusBarAnimationHidden = 1 << 1,
};

@interface PTBaseViewCotroller : UIViewController
@property (nonatomic, readonly) UIView *mainView;
@property (nonatomic, assign) BOOL showSearchBtn;
@property (nonatomic, assign) BOOL showCartBtn;
@property (nonatomic, assign) BOOL navBarHidden;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) PTStatusBarAnimationAble statusBarAnimation;
@property (nonatomic, readonly) BOOL isModal;
@property (nonatomic, assign) BOOL supportSwipeBack;
@property (nonatomic, assign) BOOL appearsFirstTime;
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, assign) BOOL hasLoadData;
@property (nonatomic, assign) BOOL isPopBacking;
@property (nonatomic, assign) BOOL navBackButtonHidden;
@property (nonatomic, strong) UIColor *navigationBarColor;
@property (nonatomic, strong) UIView *navigationBarBottomView;


- (void)viewAppearAnimateAlongsideTransition:
        (id<UIViewControllerTransitionCoordinatorContext>)context;

- (void)viewAppearAnimateAlongsideCompletion:
        (id<UIViewControllerTransitionCoordinatorContext>)context;

- (void)updateStatusBar;
- (void)updateTitle;
- (void)updateTitle:(NSString *)title;

- (BOOL)isOpening;

- (void)leftBarButtonItemOnClick;
- (void)backBarButtonItemOnClick;
- (void)closeBarButtonItemOnClick;

- (void)setupBackButton;
- (void)setNavBarColor:(UIColor *)navBarColor;

@end
