//
//  PTType11BoxGroup.m
//  PTKit
//
//  Created by LeeHu on 14/12/17.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTType11BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType11BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE11 ];
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
    CGFloat topPadding = [self collectionView:collectionView itemTopPadding:0];
    CGFloat originX = 0;
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
            layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                     inSection:section]];
        CGSize itemSize = [self collectionView:collectionView itemSize:item];
        CGFloat space = [self collectionView:collectionView itemSpace:item];
        originX += space;
        attributes.frame = CGRectMake(originX, topPadding, itemSize.width, itemSize.height);
        originX += itemSize.width;
        [sectionAttributes addObject:attributes];
    }
    CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();
    *totalHeight = itemCount > 0 ? PTRoundPixelValue(84 * sizeRatio) : 0;
    return sectionAttributes;
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
    attributes.bgColor = [UIColor whiteColor];
    attributes.hasBottomLine = YES;
    attributes.hasTopLine = hasTopLine;
    attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
    return attributes;
}

- (CGSize)collectionView:(UICollectionView *)collectionView itemSize:(NSUInteger)item
{

    CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();
    CGFloat itemWidth = PTRoundPixelValue(44 * sizeRatio);
    CGFloat itemHeight = PTRoundPixelValue(64 * sizeRatio);
    NSArray *sizeMap = @[
        NSStringFromCGSize(CGSizeMake(itemWidth, itemHeight)),
        NSStringFromCGSize(CGSizeMake(itemWidth, itemHeight)),
        NSStringFromCGSize(CGSizeMake(itemWidth, itemHeight)),
        NSStringFromCGSize(CGSizeMake(itemWidth, itemHeight)),
        NSStringFromCGSize(CGSizeMake(itemWidth, itemHeight)),
    ];

    item = item % 5;
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView itemSpace:(NSUInteger)item
{
    CGFloat space =
        PTRoundPixelValue((CGRectGetWidth(collectionView.frame) -
                           5 * [self collectionView:collectionView itemSize:0].width - 4) /
                          6);
    if (item == 0) {
        space += 2;
    }

    return space;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView itemTopPadding:(NSUInteger)item
{
    CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();

    return (PTRoundPixelValue(84 * sizeRatio) - PTRoundPixelValue(64 * sizeRatio)) / 2.0;
}

@end
