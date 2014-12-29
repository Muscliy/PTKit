//
//  PTModuleCollectionViewCell.m
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTModuleCollectionViewCell.h"
#import "PTScreen.h"

@interface PTModuleCollectionViewCell ()

@property (nonatomic, strong) UIView *selectedView;

@end

@implementation PTModuleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor redColor];

        _icon = [[PTNetworkImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor lightGrayColor];
        _topLine.hidden = YES;

        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel.hidden = YES;

        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = [UIColor lightGrayColor];

        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = [UIColor lightGrayColor];
        self.selectedView.hidden = YES;

        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_rightLine];
        [self.contentView addSubview:_bottomLine];
        [self.contentView addSubview:_topLine];
        [self.contentView addSubview:_leftLine];
        [self.contentView addSubview:self.selectedView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _icon.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    _titleLabel.frame = CGRectMake(0, 5, CGRectGetWidth(_icon.frame), 20);

    _topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5);
    _topLine.hidden = UIEdgeInsetsEqualToEdgeInsets(self.layoutAttributes.topSeparatorLineInsets,
                                                    UIEdgeInsetsMake(-1, -1, -1, -1));
    if (!self.topLine.hidden) {
        _topLine.frame = CGRectMake(self.layoutAttributes.topSeparatorLineInsets.left, 0,
                                    CGRectGetWidth(self.bounds) -
                                        (self.layoutAttributes.topSeparatorLineInsets.left +
                                         self.layoutAttributes.topSeparatorLineInsets.right),
                                    0.5);
    }

    _leftLine.hidden = UIEdgeInsetsEqualToEdgeInsets(self.layoutAttributes.leftSeparatorLineInsets,
                                                     UIEdgeInsetsMake(-1, -1, -1, -1));

    if (!self.leftLine.hidden) {
        self.leftLine.frame = CGRectMake(
            0, self.layoutAttributes.leftSeparatorLineInsets.top, 0.5,
            CGRectGetHeight(self.bounds) - (self.layoutAttributes.leftSeparatorLineInsets.top +
                                            self.layoutAttributes.leftSeparatorLineInsets.bottom));
    }
    self.rightLine.hidden = UIEdgeInsetsEqualToEdgeInsets(
        self.layoutAttributes.rightSeparatorLineInsets, UIEdgeInsetsMake(-1, -1, -1, -1));
    if (!self.rightLine.hidden) {
        self.rightLine.frame = CGRectMake(
            CGRectGetWidth(self.bounds) - 0.5, self.layoutAttributes.rightSeparatorLineInsets.top,
            0.5,
            CGRectGetHeight(self.bounds) - (self.layoutAttributes.rightSeparatorLineInsets.top +
                                            self.layoutAttributes.rightSeparatorLineInsets.bottom));
    }
    self.bottomLine.hidden = UIEdgeInsetsEqualToEdgeInsets(
        self.layoutAttributes.bottomSeparatorLineInsets, UIEdgeInsetsMake(-1, -1, -1, -1));
    if (!self.bottomLine.hidden) {
        self.bottomLine.frame = CGRectMake(
            self.layoutAttributes.bottomSeparatorLineInsets.left,
            CGRectGetHeight(self.bounds) - 0.5,
            CGRectGetWidth(self.bounds) - (self.layoutAttributes.bottomSeparatorLineInsets.left +
                                           self.layoutAttributes.bottomSeparatorLineInsets.right),
            0.5);
    }
    _selectedView.frame = self.contentView.bounds;
}

- (void)applyLayoutAttributes:(PTCollectionViewLayoutAttributes *)layoutAttributes
{
    self.layoutAttributes = layoutAttributes;
    [self setNeedsLayout];
}

- (BOOL)shouldUpdateCellWithObject:(NICollectionViewCellObject *)object
{
    self.userData = object.userInfo;

    self.titleLabel.text = [self.userData.titles firstObject];
    [self.icon setNetworkImage:self.userData.imageUrl placeholderImage:nil];

    return YES;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.selectedView.hidden = NO;
    } else {
        self.selectedView.hidden = YES;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.icon.image = nil;
    self.titleLabel.text = nil;
    self.layoutAttributes = nil;
}

+ (NICollectionViewCellObject *)createObject:(id)_delegate userData:(id)_userData
{
    PTModuleCollectionViewCellUserData *userData =
        [[PTModuleCollectionViewCellUserData alloc] init];
    NICollectionViewCellObject *cellObject =
        [[NICollectionViewCellObject alloc] initWithCellClass:[self class] userInfo:userData];
    return cellObject;
}

@end

@implementation PTModuleCollectionViewCellUserData

@end
