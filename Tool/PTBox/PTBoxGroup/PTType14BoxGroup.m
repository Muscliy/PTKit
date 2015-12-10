//
//  PTType14BoxGroup.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTType14BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType14BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE14 ];
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
        CGSize size = [[self itemSize:item] CGSizeValue];
        if (item < 3) {
            attributes.frame = CGRectMake(item == 1 ? PTRoundPixelSacle320Value(10) : 0,
                                          item > 0
                                              ? [[self itemSize:0] CGSizeValue].height +
                                                    PTRoundPixelSacle320Value(1) +
                                                    (item == 2 ? PTRoundPixelSacle320Value(0.5) : 0)
                                              : PTRoundPixelSacle320Value(1),
                                          size.width, size.height);
        } else {
            CGFloat originX = [[self itemSize:0] CGSizeValue].width + PTRoundPixelSacle320Value(2);
            NSUInteger row = item - 3;
            attributes.frame =
                CGRectMake((row % 2) * (size.width + PTRoundPixelSacle320Value(10)) + originX,
                           PTRoundPixelSacle320Value(10) +
                               (row / 2) * (size.height + PTRoundPixelSacle320Value(10)),
                           size.width, size.height);
        }
        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0
                       ? [[self itemSize:2] CGSizeValue].height * 2 + PTRoundPixelSacle320Value(2)
                       : 0;
    return sectionAttributes;
}

- (NSValue *)itemSize:(NSUInteger)item
{
    NSArray *sizeMap = @[
        NSStringFromCGSize(CGSizeMake(146 * 2, 73.5 * 2)),
        NSStringFromCGSize(CGSizeMake(126 * 2, 0.5 * 2)),
        NSStringFromCGSize(CGSizeMake(146 * 2, 74 * 2)),

        NSStringFromCGSize(CGSizeMake(75 * 2, 36 * 2)),
        NSStringFromCGSize(CGSizeMake(75 * 2, 36 * 2)),
        NSStringFromCGSize(CGSizeMake(75 * 2, 36 * 2)),

        NSStringFromCGSize(CGSizeMake(75 * 2, 36 * 2)),
        NSStringFromCGSize(CGSizeMake(75 * 2, 36 * 2)),
        NSStringFromCGSize(CGSizeMake(75 * 2, 36 * 2)),
    ];

    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    size.width = PTRoundPixelValue(size.width * sizeRatio);
    size.height = PTRoundPixelValue(size.height * sizeRatio);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
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
    attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
    attributes.topSeparatorLineInsets = UIEdgeInsetsZero;
    attributes.hasBottomLine = YES;
    attributes.hasTopLine = hasTopLine;
    return attributes;
}

@end
