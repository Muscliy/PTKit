//
//  PTCollectionViewLayoutAttributes.m
//  xmLife
//
//  Created by weihuazhang on 14/10/31.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTCollectionViewLayoutAttributes.h"

@implementation UICollectionViewLayoutAttributes (position)

- (void)offset:(CGPoint)offset
{
    CGPoint center = self.center;
    self.center = CGPointMake(center.x + offset.x, center.y + offset.y);
}

@end

@implementation PTCollectionViewLayoutAttributes

- (instancetype)init
{
    if ((self = [super init])) {
        self.contentInsets = UIEdgeInsetsZero;
        self.leftSeparatorLineInsets = UIEdgeInsetsMake(-1, -1, -1, -1);
        self.topSeparatorLineInsets = UIEdgeInsetsMake(-1, -1, -1, -1);
        self.rightSeparatorLineInsets = UIEdgeInsetsMake(-1, -1, -1, -1);
        self.bottomSeparatorLineInsets = UIEdgeInsetsMake(-1, -1, -1, -1);
        self.bgColor = [UIColor clearColor];
        self.hasBottomLine = NO;
        self.hasTopLine = NO;
        self.hasTitle = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    PTCollectionViewLayoutAttributes *att = [super copyWithZone:zone];
    att.contentInsets = self.contentInsets;
    att.leftSeparatorLineInsets = self.leftSeparatorLineInsets;
    att.topSeparatorLineInsets = self.topSeparatorLineInsets;
    att.rightSeparatorLineInsets = self.rightSeparatorLineInsets;
    att.bottomSeparatorLineInsets = self.bottomSeparatorLineInsets;
    att.bgColor = self.bgColor;
    att.hasBottomLine = self.hasBottomLine;
    att.hasTopLine = self.hasTopLine;
    att.hasTitle = self.hasTitle;
    return att;
}

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath
{
    PTCollectionViewLayoutAttributes *attributes =
        [super layoutAttributesForCellWithIndexPath:indexPath];
    attributes.zIndex = 5;
    return attributes;
}

+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                             withIndexPath:(NSIndexPath *)indexPath
{
    PTCollectionViewLayoutAttributes *attributes =
        [super layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attributes.zIndex = 10;
    return attributes;
}

@end
