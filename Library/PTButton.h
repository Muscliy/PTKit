//
//  PTButton.h
//  PTKit
//
//  Created by LeeHu on 12/17/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	PTButtonImagePositionLeft,
	PTButtonImagePositionRight
} PTButtonImagePosition;

@interface PTButton : UIControl

@property (nonatomic, assign) CGFloat distanceTitleBetweenImage;
@property (nonatomic, assign) PTButtonImagePosition imagePosition;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, strong) UILabel *titleLabel;

#pragma mark -

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;

#pragma mark -

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

@end
