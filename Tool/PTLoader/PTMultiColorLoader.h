//
//  PTMultiColorLoader.h
//  PTKit
//
//  Created by LeeHu on 12/30/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTMultiColorLoader : UIView

/**
 *  array if UIColor
 */
@property (nonatomic, strong) NSArray<UIColor *> *colors;

/**
 *  lineWidth of the stroke
 */
@property (nonatomic, assign) CGFloat lineWidth;

- (void)startAnimation;
- (void)stopAnimation;
- (void)stopAnimationAfter:(NSTimeInterval)timeInterval;
- (BOOL)isAnimating;

@end
