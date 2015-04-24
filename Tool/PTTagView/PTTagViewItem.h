//
//  PTTagViewItem.h
//  PTKit
//
//  Created by LeeHu on 15/4/15.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTTagViewItem;
@protocol PTTagViewItemDelegate <NSObject>
@required

- (void)tagViewWantsToBeDeleted:(PTTagViewItem *)tagView;

@end

@interface PTTagViewItem : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, weak) id<PTTagViewItemDelegate> delegate;

- (void)updateWithString:(NSString *)text
                    font:(UIFont *)font
      constrainedToWidth:(CGFloat)maxWidth
                 padding:(CGSize)padding
            minimumWidth:(CGFloat)minimumWidth;
- (void)setLabelText:(NSString *)text;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderColor:(CGColorRef)borderColor;
- (void)setBorderWidth:(CGFloat)borderWidth;
- (void)setTextColor:(UIColor *)textColor;
- (void)setTextShadowColor:(UIColor *)textShadowColor;
- (void)setTextShadowOffset:(CGSize)textShadowOffset;

@end
