//
//  PTModuleDecorationView.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTModuleDecorationView.h"
#import "PTCollectionViewLayoutAttributes.h"
#import "PTColorMacro.h"
#import "PTRectMacro.h"

@interface PTModuleDecorationView ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *topLine;

@end

@implementation PTModuleDecorationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = COLOR_SEPARATOR;
        [self addSubview:_line];
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_SEPARATOR;
        [self addSubview:_topLine];
        _line.hidden = YES;
        _topLine.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _line.frame = CGRectMake(0, HEIGHT(self) - 0.5, WIDTH(self), 0.5);
    _topLine.frame = CGRectMake(0, 0.5, WIDTH(self), 0.5);
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    PTCollectionViewLayoutAttributes *attributes =
    (PTCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = attributes.bgColor;
    _line.hidden = !attributes.hasBottomLine;
    _topLine.hidden = !attributes.hasTopLine;
    [self setNeedsLayout];
}


@end
