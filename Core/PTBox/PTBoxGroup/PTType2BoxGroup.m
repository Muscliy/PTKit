//
//  PTType2BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType2BoxGroup.h"
#import "PTCollectionViewLayout.h"
#import "PTUIMathUtilities.h"

@implementation PTType2BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE2 ];
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
                     dataSource:(id<PTBoxDataSource>)dataSource
                           type:(id)types
{
    CGFloat sizeRatio = [PTBoxGroup contentScale320];
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
            attributes.bottomSeparatorLineInsets = UIEdgeInsetsMake(
                0, PTRoundPixelValue(40 * sizeRatio), 0, PTRoundPixelValue(10 * sizeRatio));
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
            attributes.contentInsets = UIEdgeInsetsMake(0, PTRoundPixelValue(20 * sizeRatio), 0, 0);
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
    return UIEdgeInsetsMake(10, 10, 10, 5);
}

- (CGSize)itemSize:(NSUInteger)item
{
    CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat reactiveWidth = PTRoundPixIntValue(160 * sizeRatio);
    UIEdgeInsets insets =
        [self collectionView:nil insetForSectionAtIndex:0 dataSource:nil type:nil];

    NSArray *sizeMap = @[
        NSStringFromCGSize(
            CGSizeMake(width - insets.left - insets.right - reactiveWidth, width / 2)),
        NSStringFromCGSize(CGSizeMake(reactiveWidth, PTRoundPixelValue(width / 4))),
        NSStringFromCGSize(CGSizeMake(reactiveWidth, PTRoundPixelValue(width / 4))),
    ];

    item = item % 3;
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
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

    if (section >= 1) {
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
