//
//  PTModuleHeaderCollectionCell.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTModuleHeaderCollectionCell.h"
#import "PTFontMacro.h"
#import "PTColorMacro.h"
#import "PTUIMathUtilities.h"
#import "PTRectMacro.h"

@interface PTModuleHeaderCollectionCell ()

@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *rightIcon;

@end

@implementation PTModuleHeaderCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.titleLabel.font = Font_14;
        self.titleLabel.textColor = COLOR_EMPHASIS;
        self.titleLabel.hidden = NO;
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = Font_13_B;
        _subTitleLabel.textColor = COLOR_WARNING;
        _subTitleLabel.hidden = YES;
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        
        UIImage *icon = [UIImage imageNamed:@"icon_arrow_right_orange"];
        _rightIcon = [[UIImageView alloc] initWithImage:icon];

        [self.contentView addSubview:_subTitleLabel];
        [self.contentView addSubview:_rightIcon];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 0, 100, 20);
    [self.titleLabel sizeToFit];
    self.titleLabel.center =
        CGPointMake(self.titleLabel.center.x, PTRoundPixelValue(self.ex_height / 2.0));
    _subTitleLabel.hidden = !([self.userData.titles count] > 1);
    _rightIcon.hidden = !([self.userData.titles count] > 1);

    _rightIcon.center = CGPointMake(self.ex_width - 15 - _rightIcon.ex_width / 2,
                                    PTRoundPixelValue(self.ex_height / 2.0));
    _subTitleLabel.frame = CGRectMake(0, 0, 30, 20);
    [_subTitleLabel sizeToFit];
    _subTitleLabel.center =
        CGPointMake(PTRoundPixelValue(_rightIcon.ex_left - _subTitleLabel.ex_width / 2.0 - 5),
                    PTRoundPixelValue(self.ex_height / 2.0));
    
}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    NSArray *titles = self.userData.titles;
    _subTitleLabel.text = titles.count > 1 ? titles[1]:nil;
    return YES;
}

+ (NICollectionViewCellObject *)createObject:(id)_delegate userData:(id)_userData
{
    PTModuleCollectionViewCellUserData *userData = [[PTModuleCollectionViewCellUserData alloc] init];
    NICollectionViewCellObject *cellObject =
    [[NICollectionViewCellObject alloc] initWithCellClass:[self class] userInfo:userData];
    return cellObject;
}

@end
