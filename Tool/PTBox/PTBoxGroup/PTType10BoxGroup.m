//
//  PTType10BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType10BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType10BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE10" ];
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
attributesForItemsInSection:(NSInteger)section
                      width:(CGFloat)width
                totalHeight:(CGFloat *)totalHeight
                 dataSource:(id<PTBoxDataSource>)dataSource
                       type:(id)types
{
    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    NSMutableArray *sectionAttributes = [@[] mutableCopy];
    PTCollectionViewLayoutAttributes *attributes = nil;
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
                      layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                               inSection:section]];
        if (item % 3 != 2) {
            attributes.rightSeparatorLineInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        }
        attributes.frame =
        CGRectMake(([self itemSize:0].width) * (item % 3) +
                   ((item % 3 == 2) ? (320 - 3 * PTRoundPixelValue(320 / 3)) : 0),
                   0, [self itemSize:item % 3].width,
                   [self itemSize:item % 3].height);
        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0 ? [self itemSize:0].height : 0;
    return sectionAttributes;
}

- (CGSize)itemSize:(NSUInteger)item
{
    CGFloat pad = 320 - 3 * PTRoundPixelValue(320 / 3);
    
    NSArray *sizeMap = @[
                         NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3), 44)),
                         NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3) + pad, 44)),
                         NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3), 44)),
                         ];
    
    item = item % 3;
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    return size;
}


@end
