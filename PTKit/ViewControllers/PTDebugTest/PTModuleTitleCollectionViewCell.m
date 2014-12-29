//
//  PTModuleTitleCollectionViewCell.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTModuleTitleCollectionViewCell.h"
#import "PTFontMacro.h"
#import "PTColorMacro.h"
#import "PTRect.h"
#import "PTRectMacro.h"

@implementation PTModuleTitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.titleLabel.hidden = NO;
        self.titleLabel.font = Font_14;
        self.titleLabel.textColor = COLOR_MAIN_TEXT;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, 30, 20);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(WIDTH(self) / 2.0, HEIGHT(self) / 2.0);
}

+ (NICollectionViewCellObject *)createObject:(id)_delegate userData:(id)_userData
{
    PTModuleCollectionViewCellUserData *userData = [[PTModuleCollectionViewCellUserData alloc] init];
    NICollectionViewCellObject *cellObject =
    [[NICollectionViewCellObject alloc] initWithCellClass:[self class] userInfo:userData];
    return cellObject;
}

- (void)applyLayoutAttributes:(PTCollectionViewLayoutAttributes *)layoutAttributes
{
    layoutAttributes.topSeparatorLineInsets = UIEdgeInsetsZero;
    layoutAttributes.leftSeparatorLineInsets = UIEdgeInsetsZero;
    layoutAttributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
    layoutAttributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
    [super applyLayoutAttributes:layoutAttributes];
}

@end
