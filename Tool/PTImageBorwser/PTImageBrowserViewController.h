//
//  PTImageBrowserViewController.h
//  PTKit
//
//  Created by LeeHu on 15/3/3.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTImageBrowserUtil.h"

@class PTImageBrowserViewController;

@protocol PTImageBrowserViewControllerDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(PTImageBrowserViewController *)photoBrowser;
- (id<PTImageBrowserUtil>)photoBrowser:(PTImageBrowserViewController *)photoBrowser
                          photoAtIndex:(NSUInteger)index;

@optional

- (id<PTImageBrowserUtil>)photoBrowser:(PTImageBrowserViewController *)photoBrowser
                     thumbPhotoAtIndex:(NSUInteger)index;
- (NSString *)photoBrowser:(PTImageBrowserViewController *)photoBrowser
      titleForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(PTImageBrowserViewController *)photoBrowser
    didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(PTImageBrowserViewController *)photoBrowser
    actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(PTImageBrowserViewController *)photoBrowser
    isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(PTImageBrowserViewController *)photoBrowser
        photoAtIndex:(NSUInteger)index
     selectedChanged:(BOOL)selected;
- (void)photoBrowserDidFinishModalPresentation:(PTImageBrowserViewController *)photoBrowser;

@end

@interface PTImageBrowserViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isVCBasedStatusBarAppearance;
@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign) NSUInteger previousPageIndex;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *thumbImages;
@property (nonatomic, strong) UIScrollView *pagingScrollView;

// Appearance
@property (nonatomic, assign) BOOL previousNavBarHidden;
@property (nonatomic, assign) BOOL previousNavBarTranslucent;
@property (nonatomic, assign) UIBarStyle previousNavBarStyle;
@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;
@property (nonatomic, strong) UIColor *previousNavBarTintColor;
@property (nonatomic, strong) UIColor *previousNavBarBarTintColor;
@property (nonatomic, strong) UIBarButtonItem *previousViewControllerBackButton;
@property (nonatomic, strong) UIImage *previousNavigationBarBackgroundImageDefault;
@property (nonatomic, strong) UIImage *previousNavigationBarBackgroundImageLandscapePhone;

@property (nonatomic, weak) id<PTImageBrowserViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<PTImageBrowserViewControllerDelegate>)delegate;

- (void)reloadData;

- (void)setCurrentImageIndex:(NSUInteger)index;

- (void)showNextImageAnimated:(BOOL)animated;

- (void)showPreviousImageAnimated:(BOOL)animated;

@end
