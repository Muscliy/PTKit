//
//  PTTagView.m
//  PTKit
//
//  Created by LeeHu on 15/4/15.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTTagView.h"
#import "PTTagViewItem.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN_DEFAULT 5.0f
#define BOTTOM_MARGIN_DEFAULT 5.0f
#define FONT_SIZE_DEFAULT 13.0f
#define HORIZONTAL_PADDING_DEFAULT 7.0f
#define LIMT_HEIGHT 100.0f
#define VERTICAL_PADDING_DEFAULT 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor]
#define BORDER_WIDTH 1.0f
#define HIGHLIGHTED_BACKGROUND_COLOR [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:0.5]
#define DEFAULT_AUTOMATIC_RESIZE NO
#define DEFAULT_SHOW_TAG_MENU NO

@interface PTTagView () <PTTagViewItemDelegate>

@end

@implementation PTTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [self setClipsToBounds:NO];
        self.backgroundColor = [UIColor greenColor];
        self.automaticResize = DEFAULT_AUTOMATIC_RESIZE;
        self.highlightedBackgroundColor = HIGHLIGHTED_BACKGROUND_COLOR;
        self.font = [UIFont systemFontOfSize:FONT_SIZE_DEFAULT];
        self.labelMargin = LABEL_MARGIN_DEFAULT;
        self.bottomMargin = BOTTOM_MARGIN_DEFAULT;
        self.horizontalPadding = HORIZONTAL_PADDING_DEFAULT;
        self.verticalPadding = VERTICAL_PADDING_DEFAULT;
        self.cornerRadius = CORNER_RADIUS;
        self.borderColor = BORDER_COLOR;
        self.borderWidth = BORDER_WIDTH;
        self.textColor = TEXT_COLOR;
        self.textShadowColor = TEXT_SHADOW_COLOR;
        self.textShadowOffset = TEXT_SHADOW_OFFSET;
        self.showTagMenu = DEFAULT_SHOW_TAG_MENU;
        self.limtHeight = LIMT_HEIGHT;
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    _textArray = [[NSArray alloc] initWithArray:array];
    _sizeFit = CGSizeZero;
    if (_automaticResize) {
        [self display];
        CGFloat height = MIN(_limtHeight, _sizeFit.height);
        self.frame =
            CGRectMake(self.frame.origin.x, self.frame.origin.y, _sizeFit.width, height);
    } else {
        [self display];
    }
    
}

- (void)addTag:(NSString *)string
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.textArray];
    [mutableArray addObject:string];
    [self setTags:mutableArray];
}

- (void)setTagBackgroundColor:(UIColor *)color
{
    self.lblBackgroundColor = color;
    [self reloadItems];
}

- (void)setTagHighlightColor:(UIColor *)color
{
    self.highlightedBackgroundColor = color;
    [self reloadItems];

}

- (void)setViewOnly:(BOOL)viewOnly
{
    if (_viewOnly != viewOnly) {
        _viewOnly = viewOnly;
        [self display];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)display
{
    NSMutableArray *tagViews = [NSMutableArray array];
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[PTTagViewItem class]]) {
            PTTagViewItem *tagViewItem = (PTTagViewItem*)subview;
            for (UIGestureRecognizer *gesture in [subview gestureRecognizers]) {
                [subview removeGestureRecognizer:gesture];
            }
            
            [tagViewItem.button removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
        }
        [subview removeFromSuperview];
    }
    
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    
    NSInteger tag = 0;
    for (id text in _textArray) {
        PTTagViewItem *tagViewItem;
        if (tagViews.count > 0) {
            tagViewItem = [tagViews lastObject];
            [tagViews removeLastObject];
        }
        else {
            if ([self.tagDelegate respondsToSelector:@selector(itemForView)]) {
                tagViewItem = [self.tagDelegate itemForView];
            } else {
                tagViewItem = [[PTTagViewItem alloc] init];
            }
        }
        
        
        [tagViewItem updateWithString:text
                             font:self.font
               constrainedToWidth:self.frame.size.width - (self.horizontalPadding * 2)
                          padding:CGSizeMake(self.horizontalPadding, self.verticalPadding)
                     minimumWidth:self.minimumWidth
         ];
        
        if (gotPreviousFrame) {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + tagViewItem.frame.size.width + self.labelMargin > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + tagViewItem.frame.size.height + self.bottomMargin);
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + self.labelMargin, previousFrame.origin.y);
            }
            newRect.size = tagViewItem.frame.size;
            [tagViewItem setFrame:newRect];
        }
        
        previousFrame = tagViewItem.frame;
        gotPreviousFrame = YES;
        
        [tagViewItem setBackgroundColor:[self getBackgroundColor]];
        [tagViewItem setCornerRadius:self.cornerRadius];
        [tagViewItem setBorderColor:self.borderColor.CGColor];
        [tagViewItem setBorderWidth:self.borderWidth];
        [tagViewItem setTextColor:self.textColor];
        [tagViewItem setTextShadowColor:self.textShadowColor];
        [tagViewItem setTextShadowOffset:self.textShadowOffset];
        [tagViewItem setTag:tag];
        [tagViewItem setDelegate:self];
        
        tag++;
        
        [self addSubview:tagViewItem];
        
        if (!_viewOnly) {
            [tagViewItem.button addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
            [tagViewItem.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [tagViewItem.button addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [tagViewItem.button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        }
    }
    
    _sizeFit = CGSizeMake(self.frame.size.width, previousFrame.origin.y + previousFrame.size.height + self.bottomMargin + 1.0f);
    
}

- (CGSize)fittedSize
{
    return _sizeFit;
}

- (void)touchDownInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [[button superview] setBackgroundColor:self.highlightedBackgroundColor];
}

- (void)touchUpInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    PTTagViewItem *tagViewItem = (PTTagViewItem *)[button superview];
    [tagViewItem setBackgroundColor:[self getBackgroundColor]];

    if ([self.tagDelegate respondsToSelector:@selector(selectedTag:tagIndex:)]) {
        [self.tagDelegate selectedTag:tagViewItem.label.text tagIndex:tagViewItem.tag];
    }

    if ([self.tagDelegate respondsToSelector:@selector(selectedTag:)]) {
        [self.tagDelegate selectedTag:tagViewItem.label.text];
    }

    if (self.showTagMenu) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:tagViewItem.frame inView:self];
        [menuController setMenuVisible:YES animated:YES];
        [tagViewItem becomeFirstResponder];
    }
}

- (void)touchDragExit:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [[button superview] setBackgroundColor:[self getBackgroundColor]];
}

- (void)touchDragInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [[button superview] setBackgroundColor:[self getBackgroundColor]];
}

- (UIColor *)getBackgroundColor
{
    if (!_lblBackgroundColor) {
        return BACKGROUND_COLOR;
    } else {
        return _lblBackgroundColor;
    }
}

- (void)reloadItems
{
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[PTTagViewItem class]]) {
            PTTagViewItem *tagViewItem = (PTTagViewItem*)subview;
            [tagViewItem setBackgroundColor:[self getBackgroundColor]];
            [tagViewItem setCornerRadius:self.cornerRadius];
            [tagViewItem setBorderColor:self.borderColor.CGColor];
            [tagViewItem setBorderWidth:self.borderWidth];
            [tagViewItem setTextColor:self.textColor];
            [tagViewItem setTextShadowColor:self.textShadowColor];
            [tagViewItem setTextShadowOffset:self.textShadowOffset];
            [tagViewItem setDelegate:self];
            
            [tagViewItem.button removeTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
            [tagViewItem.button removeTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [tagViewItem.button removeTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [tagViewItem.button removeTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
            if (!_viewOnly) {
                [tagViewItem.button addTarget:self action:@selector(touchDownInside:) forControlEvents:UIControlEventTouchDown];
                [tagViewItem.button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                [tagViewItem.button addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
                [tagViewItem.button addTarget:self action:@selector(touchDragInside:) forControlEvents:UIControlEventTouchDragInside];
            }
        }
    }

}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self reloadItems];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self reloadItems];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self reloadItems];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self reloadItems];
}

- (void)setTextShadowColor:(UIColor *)textShadowColor
{
    _textShadowColor = textShadowColor;
    [self reloadItems];
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset
{
    _textShadowOffset = textShadowOffset;
    [self reloadItems];
}

- (void)setLimtHeight:(CGFloat)limtHeight
{
    _limtHeight = limtHeight;
    CGFloat height = MIN(_limtHeight, _sizeFit.height);
    self.frame =
    CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), height);
}

#pragma mark - DWTagViewDelegate

- (void)tagViewWantsToBeDeleted:(PTTagViewItem *)tagViewItem
{
    NSMutableArray *mTextArray = [self.textArray mutableCopy];
    [mTextArray removeObject:tagViewItem.label.text];
    [self setTags:mTextArray];

    if ([self.tagDelegate respondsToSelector:@selector(tagListTagsChanged:)]) {
        [self.tagDelegate tagListTagsChanged:self];
    }
}

@end
