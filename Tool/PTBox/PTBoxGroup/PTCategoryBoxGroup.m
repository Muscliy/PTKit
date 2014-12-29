//
//  PTCategoryBoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/7.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTCategoryBoxGroup.h"
#import "HomePageModuleConstant.h"
#import "PTUIMathUtilities.h"
@implementation PTCategoryBoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_USERCOLLECT, CC_HOMEPAGEMODULECONSTANT_CATEGORY ];
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
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGSize size = CGSizeZero;
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
            layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                     inSection:section]];
        if (item % 3 != 2) {
            attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
        }
        attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;

        if ([dataSource respondsToSelector:@selector(collectionView:sizeForItemAtIndexPath:)]) {
            size =
                [dataSource collectionView:collectionView
                    sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
        }

        attributes.frame = CGRectMake(originX, originY, size.width, size.height);
        NSUInteger a = (item + 1) % 3;

        originX = ((a == 0) ? 0 : originX + size.width);
        originY = ((a == 0) ? (originY + size.height) : originY);

        [sectionAttributes addObject:attributes];
    }
    *totalHeight = ((itemCount % 3) ? originY + size.height : originY);

    return sectionAttributes;
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                         attributeForHeaderInSection:(NSInteger)section
                                               width:(CGFloat)width
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)type
{
    PTCollectionViewLayoutAttributes *attributes = [PTCollectionViewLayoutAttributes
        layoutAttributesForSupplementaryViewOfKind:PTCollectionViewLayoutKindBoxGroupHeader
                                     withIndexPath:[NSIndexPath indexPathForItem:0
                                                                       inSection:section]];
    CGSize size = CGSizeZero;
    if ([dataSource
            respondsToSelector:@selector(collectionView:referenceSizeForHeaderInSection:)]) {
        size = [dataSource collectionView:collectionView referenceSizeForHeaderInSection:section];
    }
    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    attributes.frame = itemCount < 1 ? CGRectZero : CGRectMake(0, 0, size.width, size.height);

    return attributes;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    if ([dataSource respondsToSelector:@selector(collectionView:insetForSection:)]) {
        return [dataSource collectionView:collectionView insetForSection:section];
    }

    return UIEdgeInsetsZero;
}

@end
