//
//  PTType4BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType4BoxGroup.h"
#import "PTUIMathUtilities.h"

#define ITEM_SPACE 10

@implementation PTType4BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[
        CC_HOMEPAGEMODULECONSTANT_TYPE4,
        CC_HOMEPAGEMODULECONSTANT_TYPE5,
        CC_HOMEPAGEMODULECONSTANT_TYPE7,
        CC_HOMEPAGEMODULECONSTANT_TYPE15
    ];
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
                     dataSource:(id<PTBoxDataSource>)dataSource
                           type:(id)types
{
    BOOL hasTopLine = NO;
    NSArray *showTypes = @[ CC_HOMEPAGEMODULECONSTANT_TYPE8, CC_HOMEPAGEMODULECONSTANT_TYPE9 ];

    if (section > 1) {
        NSString *aType = types[section - 1];
        hasTopLine = [showTypes containsObject:aType];
    }
    id type = types[section];
    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    NSMutableArray *sectionAttributes = [@[] mutableCopy];
    PTCollectionViewLayoutAttributes *attributes = nil;

    SEL selSize = NSSelectorFromString(
        [NSString stringWithFormat:@"collectionView:item%@Size:", (NSString *)type]);

    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
            layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                     inSection:section]];
        if (item % 2 != 1 && ![type isEqualToString:CC_HOMEPAGEMODULECONSTANT_TYPE7]) {
            attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
        }
        NSValue *ret;
        PTPerformSelectorLeakWarning(
            ret = [self performSelector:selSize withObject:collectionView withObject:@(item % 2)]);
        NSValue *firstValue;
        PTPerformSelectorLeakWarning(
            firstValue = [self performSelector:selSize withObject:collectionView withObject:@(0)]);

        CGSize size = [ret CGSizeValue];

        CGSize firstSize = [firstValue CGSizeValue];

        attributes.frame = CGRectMake(
            (item % 2) * (firstSize.width + ([type isEqualToString:@"TYPE7"] ? ITEM_SPACE : 0)),
            (item / 2) * firstSize.height, size.width, size.height);
        if (![CC_HOMEPAGEMODULECONSTANT_TYPE7 isEqualToString:type]) {
            if ([CC_HOMEPAGEMODULECONSTANT_TYPE15 isEqualToString:type]) {
                if (item == 0) {
                    attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
                }
            }
            attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
            attributes.topSeparatorLineInsets =
                hasTopLine ? UIEdgeInsetsZero : attributes.topSeparatorLineInsets;
        }

        [sectionAttributes addObject:attributes];
    }

    NSValue *ret;
    PTPerformSelectorLeakWarning(
        ret = [self performSelector:selSize withObject:collectionView withObject:@(0)]);
    CGSize size = [ret CGSizeValue];
    // SAVE: 后台返回数据暂时只有单行
    *totalHeight = size.height * ((itemCount + 1) / 2);
    return sectionAttributes;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemTYPE4Size:(NSNumber *)num
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSUInteger item = [num integerValue];
    NSArray *sizeMap = @[
        NSStringFromCGSize(
            CGSizeMake(width - PTRoundPixelValue(width / 3), PTRoundPixelSacle320Value(100))),
        NSStringFromCGSize(
            CGSizeMake(PTRoundPixelValue(width / 3), PTRoundPixelSacle320Value(100))),
    ];

    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemTYPE5Size:(NSNumber *)num
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSUInteger item = [num integerValue];
    NSArray *sizeMap = @[
        NSStringFromCGSize(
            CGSizeMake(PTRoundPixelValue(width / 3), PTRoundPixelSacle320Value(100))),
        NSStringFromCGSize(
            CGSizeMake(width - PTRoundPixelValue(width / 3), PTRoundPixelSacle320Value(100))),
    ];

    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemTYPE7Size:(NSNumber *)num
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSUInteger item = [num integerValue];
    NSArray *sizeMap = @[
        NSStringFromCGSize(
            CGSizeMake((width - 3 * ITEM_SPACE) / 2.0, PTRoundPixelSacle320Value(80))),
        NSStringFromCGSize(
            CGSizeMake((width - 3 * ITEM_SPACE) / 2.0, PTRoundPixelSacle320Value(80))),
    ];

    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemTYPE15Size:(NSNumber *)num
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSUInteger item = [num integerValue];
    NSArray *sizeMap = @[
        NSStringFromCGSize(CGSizeMake(width / 2, PTRoundPixelSacle320Value(54))),
        NSStringFromCGSize(CGSizeMake(width / 2, PTRoundPixelSacle320Value(54))),
    ];

    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    if ([type isEqualToString:CC_HOMEPAGEMODULECONSTANT_TYPE7]) {
        return UIEdgeInsetsMake(0, ITEM_SPACE, 0, ITEM_SPACE);
    }

    return UIEdgeInsetsZero;
}

@end
