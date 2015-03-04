//
//  PTImageBrowserViewController.m
//  PTKit
//
//  Created by LeeHu on 15/3/3.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTImageBrowserViewController.h"
#import "SDImageCache.h"


@interface PTImageBrowserViewController ()

@end

@implementation PTImageBrowserViewController

- (void)dealloc
{
    _pagingScrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)init
{
    if ((self = [super init])) {
        [self initialisation];
    }
    return self;
}

#pragma mark - public method
- (instancetype)initWithDelegate:(id<PTImageBrowserViewControllerDelegate>)delegate
{
    if ((self = [super init])) {
        _delegate = delegate;
    }
    return self;
}

- (void)setCurrentImageIndex:(NSUInteger)index
{
}

- (void)showNextImageAnimated:(BOOL)animated
{

}

- (void)showPreviousImageAnimated:(BOOL)animated
{
}

- (void)reloadData
{
}

#pragma mark - Private method

- (void)initialisation
{
    NSNumber *isVCBasedStatusBarAppearanceNum = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    
    if (isVCBasedStatusBarAppearanceNum) {
        _isVCBasedStatusBarAppearance = isVCBasedStatusBarAppearanceNum.boolValue;
    } else {
        _isVCBasedStatusBarAppearance = YES;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0) self.wantsFullScreenLayout = YES;
#endif
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)releaseAllUnderlyingImages:(BOOL)preserveCurrent
{
    NSArray *copy = [self.images copy];
    for (id image in copy) {
        if (image != [NSNull null]) {
            if (preserveCurrent && image == [self imageAtIndex:self.currentPageIndex]) {
                continue;
            }
        }
        [image unloadUnderlyingImage];
    }

    copy = [self.thumbImages copy];
    for (id image in copy) {
        if (image != [NSNull null]) {
            [image unloadUnderlyingImage];
        }
    }
}

- (id<PTImageBrowserUtil>)imageAtIndex:(NSUInteger)index
{
    return nil;
}

@end
