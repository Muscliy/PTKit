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
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE3 ];
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
    // SAVE: 后台返回数据暂时只有单行
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

        attributes.frame = CGRectMake(
            ([self collectionView:collectionView itemSize:0].width) * (item % 3) +
                ((item % 3 == 2)
                     ? (WIDTH(collectionView) - 3 * PTRoundPixelValue(WIDTH(collectionView) / 3))
                     : 0),
            [self collectionView:collectionView itemSize:0].height * (lines - 1),
            [self collectionView:collectionView itemSize:item % 3].width,
            [self collectionView:collectionView itemSize:item % 3].height);
        attributes.topSeparatorLineInsets =
            hasTopLine ? UIEdgeInsetsZero : attributes.topSeparatorLineInsets;

        [sectionAttributes addObject:attributes];
    }
    *totalHeight =
        itemCount > 0 ? ([self collectionView:collectionView itemSize:0].height * lines) : 0;
    return sectionAttributes;
}

- (CGSize)collectionView:(UICollectionView *)collectionView itemSize:(NSUInteger)item
{
    CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();
    CGSize visibleSize =
        CGSizeMake(collectionView.frame.size.width, PTRoundPixelValue(100 * sizeRatio));

    CGFloat pad = visibleSize.width - 3 * PTRoundPixelValue(visibleSize.width / 3);

    CGFloat itemWidth = PTRoundPixelValue(visibleSize.width / 3);
    NSArray *sizeMap = @[
        NSStringFromCGSize(CGSizeMake(itemWidth, visibleSize.height)),
        NSStringFromCGSize(CGSizeMake(itemWidth + pad, visibleSize.height)),
        NSStringFromCGSize(CGSizeMake(itemWidth, visibleSize.height)),
    ];

    item = item % 3;
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
        return size;
}

@end
