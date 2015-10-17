//
//  PTBaseViewCotroller.m
//  PTKit
//
//  Created by LeeHu on 14/12/1.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTBaseViewCotroller.h"
#import "PTOSMacro.h"
#import "PTRectMacro.h"
#import "PTLogger.h"
#import "UINavigationBar+Extents.h"
#import "PTNavigationController.h"
#import "UIColor+Extents.h"

@interface PTBaseViewCotroller () {
    struct {
        unsigned int _hasChangeNavBar : 1;    // changeByUser
        unsigned int _hasChangeStatusBar : 1; // changeByUser
        unsigned int isAppear : 1;
        unsigned int appearsFirstTime : 1;
        unsigned int hasLoadData : 1;
        unsigned int isPopBacking : 1;
    } elViewControllerFlags_;
    long long lastOpenTime;
}

@end

@implementation PTBaseViewCotroller

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.appearsFirstTime = YES;
        _supportSwipeBack = YES;
        _statusBarAnimation = PTStatusBarAnimationShow;
        _showCartBtn = NO;
    }
    return self;
}

#pragma mark - elViewControllerFlags method
- (BOOL)isAppear
{
    return elViewControllerFlags_.isAppear;
}

- (void)setIsAppear:(BOOL)isAppear
{
    elViewControllerFlags_.isAppear = isAppear;
}

- (BOOL)hasLoadData
{
    return elViewControllerFlags_.hasLoadData;
}

- (void)setHasLoadData:(BOOL)hasLoadData
{
    if (hasLoadData)
        elViewControllerFlags_.hasLoadData = 1;
    else
        elViewControllerFlags_.hasLoadData = 0;
}

- (BOOL)appearsFirstTime
{
    return elViewControllerFlags_.appearsFirstTime;
}

- (void)setAppearsFirstTime:(BOOL)appearsFirstTime
{
    elViewControllerFlags_.appearsFirstTime = appearsFirstTime;
}

- (BOOL)hasChangeNavBar
{
    return elViewControllerFlags_._hasChangeNavBar;
}

- (void)setHasChangeNavBar:(BOOL)hasChangeNavBar
{
    elViewControllerFlags_._hasChangeNavBar = hasChangeNavBar;
}

- (BOOL)hasChangeStatusBar
{
    return elViewControllerFlags_._hasChangeStatusBar;
}

- (void)setHasChangeStatusBar:(BOOL)hasChangeStatusBar
{
    elViewControllerFlags_._hasChangeStatusBar = hasChangeStatusBar;
}

- (BOOL)isPopBacking
{
    return elViewControllerFlags_.isPopBacking;
}

- (void)setIsPopBacking:(BOOL)isPopBacking
{
    elViewControllerFlags_.isPopBacking = isPopBacking;
}

//==============================================================================
//==============================================================================

- (void)dealloc
{
    PTLogDebug(@"%@ dealloc", [NSString stringWithUTF8String:object_getClassName(self)]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (UIView *)mainView
{
    return self.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_SHADE;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (!self.navBackButtonHidden) {
        [self setupBackButton];
    }
}

- (void)setupBackButton
{
    self.navigationItem.leftBarButtonItem =
        [self.navigationController ex_leftBarButtonItem:self
                                                 action:@selector(leftBarButtonItemOnClick)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    PTLogWarn(@"didReceiveMemoryWarning");
}

- (void)loadView
{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupStatusBarStatus];
    [self setupTransitionCoordinator];
    [self setupNavBarStatus];
    [self setupNavigationBottomView];

    lastOpenTime = CACurrentMediaTime();
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isAppear = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
      self.isPopBacking = NO;
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isPopBacking = NO;
    PTLogDebug(@"%@ viewWillDisappear", [NSString stringWithUTF8String:object_getClassName(self)]);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.isAppear = NO;
}

- (BOOL)isModal
{
    if (self.navigationController == nil || self.navigationController.viewControllers.count <= 1) {
        if (self.presentingViewController) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isOpening
{
    return CACurrentMediaTime() - lastOpenTime < 500;
}

- (void)handleSwipeBack:(UISwipeGestureRecognizer *)swiper
{
    if (self.navigationController.viewControllers.count < 2) {
        return;
    }

    if ([swiper locationInView:self.view].y < (CGRectGetHeight(self.view.frame) - 220)) {
        return;
    }

    PTLogDebug(@"swipe Back");

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemOnClick
{
    [self.view endEditing:YES];
    if (!self.isAppear) {
        return;
    }
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self backBarButtonItemOnClick];
    } else if (self.presentingViewController) {
        [self closeBarButtonItemOnClick];
    }
}

- (void)backBarButtonItemOnClick
{
    if (self.navigationController.viewControllers.count < 2) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeBarButtonItemOnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NavigationBar

- (void)setupNavBarStatus
{
    if (self.navigationController.navigationBarHidden != self.navBarHidden) {
        [self.navigationController setNavigationBarHidden:self.navBarHidden
                                                 animated:!self.navBarHidden];
    }
}

- (void)setupNavigationBottomView
{
    _navigationBarBottomView =
        [[UIView alloc] initWithFrame:CGRectMake(0, -(kTopBarHeight + kPTStatusBarHeight),
                                                 [UIScreen mainScreen].bounds.size.width,
                                                 kTopBarHeight + kPTStatusBarHeight)];
    _navigationBarBottomView.backgroundColor = self.navigationBarColor;
    [self.view addSubview:_navigationBarBottomView];
}

- (void)setNavBarHidden:(BOOL)navBarHidden
{
    self.hasChangeNavBar = YES;
    _navBarHidden = navBarHidden;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if (parent) {
        if (!self.hasChangeNavBar) {
            UINavigationController *navc = self.navigationController;
            if (navc) {
                _navBarHidden = navc.navigationBarHidden;
            }
        }
        if (!self.hasChangeStatusBar) {
            _statusBarHidden = _navBarHidden;
        }
    } else {
        //移除
        UINavigationController *navc = self.navigationController;
        if (navc) {
            NSMutableArray *viewControllers = [navc.viewControllers mutableCopy];
            [viewControllers removeLastObject];
            PTBaseViewCotroller *preVC = [viewControllers lastObject];
            if (preVC && [preVC respondsToSelector:@selector(setIsPopBacking:)]) {
                [preVC setIsPopBacking:YES];
            }
        }
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    self.appearsFirstTime = NO;
}

- (UIColor *)navigationBarColor
{
    return COLOR_TITLEBAR_GREEN;
}

- (void)setNavBarColor:(UIColor *)navBarColor
{
    self.navigationBarColor = navBarColor;
    self.navigationBarBottomView.backgroundColor = navBarColor;
    [self.navigationController.navigationBar ex_setBackgroundColor:navBarColor];
}

#pragma mark - StatusBar

- (void)updateStatusBar
{
    if (PTOS_IOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setupStatusBarStatus
{
    if (!self.hasChangeStatusBar) {
        [self _applyStatusBarHidden:self.navBarHidden];
    } else {
        [self _applyStatusBarHidden:self.statusBarHidden];
    }
}

- (void)setupTransitionCoordinator
{
    PTWeakSelf;
    [[self transitionCoordinator]
        animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
          PTStrongSelf;
          [self viewAppearAnimateAlongsideTransition:context];
        }
        completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
          PTStrongSelf;
          [self viewAppearAnimateAlongsideCompletion:context];
        }];
}

- (void)viewAppearAnimateAlongsideTransition:
        (id<UIViewControllerTransitionCoordinatorContext>)context
{
    if ([self.navigationBarColor ex_isEqualToColor:self.navigationController.navigationBar
         .ex_colorLayer.backgroundColor]) {
        return;
    }
    [self.navigationController.navigationBar ex_setBackgroundColor:self.navigationBarColor];
}

- (void)viewAppearAnimateAlongsideCompletion:
        (id<UIViewControllerTransitionCoordinatorContext>)context
{
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    self.hasChangeStatusBar = YES;
    [self _applyStatusBarHidden:statusBarHidden];
}

- (void)_applyStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHidden
                                            withAnimation:[self statusBarNeedAnimation]];
    [self updateStatusBar];
}

- (BOOL)statusBarNeedAnimation
{
    if ((_statusBarHidden && _statusBarAnimation & PTStatusBarAnimationHidden) ||
        (!_statusBarHidden && _statusBarAnimation & PTStatusBarAnimationShow)) {
        return YES;
    }
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return [self statusBarNeedAnimation] ? UIStatusBarAnimationFade : UIStatusBarAnimationNone;
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

#pragma mark - private app
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self updateTitle:title];
}

- (void)updateTitle
{
    [self updateTitle:self.title];
}

- (void)updateTitle:(NSString *)title
{
}

@end
