//
//  PTPagerTabStripButtonBarViewCell.m
//  PTKit
//
//  Created by LeeHu on 5/7/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTPagerTabStripButtonBarViewCell.h"

@implementation PTPagerTabStripButtonBarViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:17.0f];
        _label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = (CGRect){.origin = CGPointZero, .size = self.contentView.bounds.size};
    
}

@end
