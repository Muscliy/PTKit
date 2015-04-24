//
//  PTTagViewItem.m
//  PTKit
//
//  Created by LeeHu on 15/4/15.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTTagViewItem.h"

#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor]
#define BORDER_WIDTH 1.0f
#define CORNER_RADIUS 10.0f

@implementation PTTagViewItem

- (instancetype)init
{
    if ((self = [super init])) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_label setTextColor:TEXT_COLOR];
        [_label setShadowColor:TEXT_SHADOW_COLOR];
        [_label setShadowOffset:TEXT_SHADOW_OFFSET];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_label];

        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.autoresizingMask =
            UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_button setFrame:self.frame];
        [self addSubview:_button];

        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:CORNER_RADIUS];
        [self.layer setBorderColor:BORDER_COLOR.CGColor];
        [self.layer setBorderWidth:BORDER_WIDTH];
    }
    return self;
}

- (void)updateWithString:(id)text
                    font:(UIFont *)font
      constrainedToWidth:(CGFloat)maxWidth
                 padding:(CGSize)padding
            minimumWidth:(CGFloat)minimumWidth
{
    CGSize textSize = CGSizeZero;
    BOOL isTextAttributedString = [text isKindOfClass:[NSAttributedString class]];

    if (isTextAttributedString) {
        NSMutableAttributedString *attributedString =
            [[NSMutableAttributedString alloc] initWithAttributedString:text];
        [attributedString addAttributes:@{
            NSFontAttributeName : font
        } range:NSMakeRange(0, ((NSAttributedString *)text).string.length)];

        textSize = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil].size;
        _label.attributedText = [attributedString copy];
    } else {
        textSize =
            [text sizeWithFont:font forWidth:maxWidth lineBreakMode:NSLineBreakByTruncatingTail];
        _label.text = text;
    }

    textSize.width = MAX(textSize.width, minimumWidth);
    textSize.height += padding.height * 2;

    self.frame = CGRectMake(0, 0, textSize.width + padding.width * 2, textSize.height);
    _label.frame =
        CGRectMake(padding.width, 0, MIN(textSize.width, self.frame.size.width), textSize.height);
    _label.font = font;

    [_button setAccessibilityLabel:self.label.text];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setBorderColor:(CGColorRef)borderColor
{
    [self.layer setBorderColor:borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

- (void)setLabelText:(NSString *)text
{
    [_label setText:text];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_label setTextColor:textColor];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor
{
    [_label setShadowColor:textShadowColor];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset
{
    [_label setShadowOffset:textShadowOffset];
}

#pragma mark - UIMenuController support

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:)) || (action == @selector(delete:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.label.text];
}

- (void) delete:(id)sender
{
    [self.delegate tagViewWantsToBeDeleted:self];
}

@end
