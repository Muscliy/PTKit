//
//  UINavigationBar+Extents.h
//  PTKit
//
//  Created by LeeHu on 4/24/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Extents)

- (void)pt_setTranslationY:(CGFloat)translationY;
- (void)pt_setContentAlpha:(CGFloat)alpha;
- (void)pt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)pt_reset;
- (void)pt_scrollViewDidScroll:(UIScrollView *)scrollView;

@end
