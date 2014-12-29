//
//  PTType3BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType3BoxGroup.h"
#import "HomePageModuleConstant.h"
#import "PTUIMathUtilities.h"

@implementation PTType3BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE3" ];
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

    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    NSMutableArray *sectionAttributes = [@[] mutableCopy];
    NSUInteger lines = (itemCount + 2) / 3;
    PTCollectionViewLayoutAttributes *attributes = nil;
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
            layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                     inSection:section]];
        if (item % 3 != 2) {
            attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
        }
        attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;

        attributes.frame =
            CGRectMake(([self itemSize:0].width) * (item % 3) +
                           ((item % 3 == 2) ? (320 - 3 * PTRoundPixelValue(320 / 3)) : 0),
                       [self itemSize:0].height * (lines - 1), [self itemSize:item % 3].width,
                       [self itemSize:item % 3].height);
        attributes.topSeparatorLineInsets =
            hasTopLine ? UIEdgeInsetsZero : attributes.topSeparatorLineInsets;

        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0 ? ([self itemSize:0].height * lines) : 0;
    return sectionAttributes;
}

- (CGSize)itemSize:(NSUInteger)item
{
    CGFloat pad = 320 - 3 * PTRoundPixelValue(320 / 3);

    NSArray *sizeMap = @[
        NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3), 100)),
        NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3) + pad, 100)),
        NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3), 100)),
    ];

    item = item % 3;
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    return size;
}

@end
