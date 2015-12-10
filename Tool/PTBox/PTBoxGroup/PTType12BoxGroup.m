//
//  PTType12BoxGroup.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTType12BoxGroup.h"
#import "PTUIMathUtilities.h"

#define ITEM_SPACE 10

@implementation PTType12BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE12 ];
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
        CGSize size = [[self collectionView:collectionView itemSize:item] CGSizeValue];
        switch (item) {
        case 0: {
            attributes.frame = CGRectMake(ITEM_SPACE, 0, size.width, size.height);
            break;
        }
        case 1: {
            attributes.frame =
                CGRectMake(ITEM_SPACE * 2 +
                               [[self collectionView:collectionView itemSize:0] CGSizeValue].width,
                           0, size.width, size.height);
            break;
        }
        case 2: {
            attributes.frame = CGRectMake(
                ITEM_SPACE * 2 +
                    [[self collectionView:collectionView itemSize:0] CGSizeValue].width,
                [[self collectionView:collectionView itemSize:0] CGSizeValue].height - size.height,
                size.width, size.height);
            break;
        }
        case 3: {
            attributes.frame = CGRectMake(
                ITEM_SPACE * 5 / 2.0 +
                    [[self collectionView:collectionView itemSize:0] CGSizeValue].width +
                    [[self collectionView:collectionView itemSize:2] CGSizeValue].width,
                [[self collectionView:collectionView itemSize:0] CGSizeValue].height - size.height,
                size.width, size.height);
            break;
        }
        default:
            break;
        }
        attributes.leftSeparatorLineInsets = UIEdgeInsetsZero;
        attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
        attributes.topSeparatorLineInsets = UIEdgeInsetsZero;
        attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
        [sectionAttributes addObject:attributes];
    }
    *totalHeight =
        itemCount > 0 ? [[self collectionView:collectionView itemSize:0] CGSizeValue].height : 0;
    return sectionAttributes;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemSize:(NSUInteger)item
{

    CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();
    CGSize visibleSize = CGSizeMake(collectionView.frame.size.width - ITEM_SPACE * 3,
                                    PTRoundPixelValue(160 * sizeRatio));
    NSArray *sizeMap = @[
        NSStringFromCGSize(
            CGSizeMake(PTRoundPixelValue(visibleSize.width * 13.0 / 29.0), visibleSize.height)),
        NSStringFromCGSize(
            CGSizeMake(visibleSize.width - PTRoundPixelValue(visibleSize.width * (13.0 / 29.0)),
                       PTRoundPixelValue((visibleSize.height - ITEM_SPACE) / 2.0))),
        NSStringFromCGSize(
            CGSizeMake(PTRoundPixelValue((visibleSize.width -
                                          PTRoundPixelValue(visibleSize.width * (13.0 / 29.0)) -
                                          ITEM_SPACE / 2) /
                                         2.0),
                       PTRoundPixelValue((visibleSize.height - ITEM_SPACE) / 2.0))),
        NSStringFromCGSize(
            CGSizeMake(PTRoundPixelValue((visibleSize.width -
                                          PTRoundPixelValue(visibleSize.width * (13.0 / 29.0)) -
                                          ITEM_SPACE / 2) /
                                         2.0),
                       PTRoundPixelValue((visibleSize.height - ITEM_SPACE) / 2.0))),
    ];
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                 attributeForDecorationViewInSection:(NSInteger)section
                                                size:(CGSize)size
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)types
{
    PTCollectionViewLayoutAttributes *attributes = [PTCollectionViewLayoutAttributes
        layoutAttributesForDecorationViewOfKind:PTCollectionViewLayoutKindBoxGroupBg
                                  withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    attributes.frame = CGRectMake(0, 0, size.width, size.height);
    attributes.bgColor = COLOR_SHADE;
    return attributes;
}

@end
