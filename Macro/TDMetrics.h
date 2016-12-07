
//
//  TDMetrics.h
//  PTKit
//
//  Created by LeeHu on 12/7/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#ifndef TDMetrics_h
#define TDMetrics_h

static const CGFloat kNavigationSectionHeight = 64;
static const CGFloat kNavigationBarHeight = 44;
static const CGFloat kTabBarHeight = 49;
static const CGFloat kStatusBarHeight = 20;
static const CGFloat kCellDefaultHeight = (44.f);


#define kScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)

#define kScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

#define kScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

#endif /* TDMetrics_h */
