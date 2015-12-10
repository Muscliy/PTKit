//
//  PTNavigationBar.h
//  PTKit
//
//  Created by LeeHu on 15/2/6.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTNavigationBar : UIView<UIAppearance, UIAppearanceContainer>

/**
 *  标题文字
 */
@property(nullable, nonatomic, strong) NSString *title;

/**
 *  titleview
 */
@property(nullable, nonatomic, strong) UIView *titleView;

/**
 *  标题的 label
 */
@property(nullable, nonatomic, readonly) UILabel *titleLabel;


@property (nullable, nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nullable, nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nullable, nonatomic, copy) NSArray<UIBarButtonItem *> *leftBarButtonItems;
@property (nullable, nonatomic, copy) NSArray<UIBarButtonItem *> *rightBarButtonItems;

/**
 *  放置内容的 view，不包含状态栏
 */
@property(nullable, nonatomic, strong) UIView *containerView;

/**
 *  放置内容的 view，不包含状态栏
 */
@property(nullable, nonatomic, strong) UIView *leftBarButtonItemcontainerView;
@property(nullable,nonatomic, strong) UIView *rightBarButtonItemcontainerView;


/**
 *  用于毛玻璃效果
 */
@property(nullable, nonatomic, strong) UIVisualEffectView *effectView;

#pragma mark - Appearances
/**
 *  设置标题文字样式
 */
@property (nullable, nonatomic, copy) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;


/**
 *  设置标题颜色
 *
 *  @param color 标题颜色
 */
- (void)setTitleColor:(nullable UIColor *)color;

/**
 *  创建 navigation bar
 *
 *  @param frame          frame
 *  @param needBlurEffect 是否需要模糊效果 (iOS 8 以上支持)
 *
 *  @return
 */
- (nonnull instancetype)initWithFrame:(CGRect)frame needBlurEffect:(BOOL)needBlurEffect;


/**
 *  设置navigation bar的border
 *
 *  @param color navigation bar的border的色值
 */
- (void)setBottomBorderColor:(nullable UIColor*)color;

@end

