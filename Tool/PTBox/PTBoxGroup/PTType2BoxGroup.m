//
//  PTType2BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType2BoxGroup.h"
#import "PTCollectionViewLayout.h"

@implementation PTType2BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE2" ];
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
                     dataSource:(id<PTBoxDataSource>)dataSource
                           type:(id)types
{
    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    NSMutableArray *sectionAttributes = [@[] mutableCopy];
    PTCollectionViewLayoutAttributes *attributes = nil;
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
            layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                     inSection:section]];
        NSInteger residue = item % 3;
        switch (residue) {
        case 0: {
            attributes.hasTitle = YES;
            break;
        }

        case 1: {
            attributes.bottomSeparatorLineInsets =
                UIEdgeInsetsMake(0, 40 * sizeRatio, 0, 10 * sizeRatio);
            break;
        }

        case 2: {
            break;
        }
        }
        if (residue == 0) {
            attributes.frame =
                CGRectMake(0, 0, [self itemSize:item].width, [self itemSize:item].height);
        } else {
            attributes.frame =
                CGRectMake([self itemSize:0].width, (residue > 1 ? [self itemSize:item].height : 0),
                           [self itemSize:item].width, [self itemSize:item].height);
            attributes.contentInsets = UIEdgeInsetsMake(0, 20 * sizeRatio, 0, 0);
        }

        [sectionAttributes addObject:attributes];
    }

    *totalHeight = itemCount > 0 ? [self itemSize:0].height : 0;

    return sectionAttributes;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    return UIEdgeInsetsMake(20 * sizeRatio, 20 * sizeRatio, 20 * sizeRatio, 10 * sizeRatio);
}

- (CGSize)itemSize:(NSUInteger)item
{
    NSArray *sizeMap = @[
        NSStringFromCGSize(CGSizeMake(290, 320)),
        NSStringFromCGSize(CGSizeMake(320, 160)),
        NSStringFromCGSize(CGSizeMake(320, 160)),
    ];

    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    item = item % 3;
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    size.width = size.width * sizeRatio;
    size.height = size.height * sizeRatio;
    return size;
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                 attributeForDecorationViewInSection:(NSInteger)section
                                                size:(CGSize)size
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)types
{
    BOOL hasTopLine = NO;
    NSArray *showTypes = @[ CC_HOMEPAGEMODULECONSTANT_TYPE8, CC_HOMEPAGEMODULECONSTANT_TYPE9 ];

    if (section > 1) {
        NSString *aType = types[section - 1];
        hasTopLine = [showTypes containsObject:aType];
    }
    PTCollectionViewLayoutAttributes *attributes = [PTCollectionViewLayoutAttributes
        layoutAttributesForDecorationViewOfKind:PTCollectionViewLayoutKindBoxGroupBg
                                  withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    attributes.frame = CGRectMake(0, 0, size.width, size.height);
    attributes.hasBottomLine = YES;
    attributes.hasTopLine = hasTopLine;
    attributes.bgColor = [UIColor whiteColor];
    return attributes;
}

@end
