//
//  PTType1BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType1BoxGroup.h"
#import "PTCollectionViewLayout.h"
#import "PTUIMathUtilities.h"

@implementation PTType1BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    //可以换成两个类实现
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE1 ];
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
        NSInteger residue = item % 5;
        switch (residue) {
        case 0: {
            attributes.hasTitle = YES;
            break;
        }

        case 1: {
            attributes.bottomSeparatorLineInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            attributes.rightSeparatorLineInsets = UIEdgeInsetsMake(20, 0, 0, 0);
            break;
        }

        case 2: {
            attributes.bottomSeparatorLineInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            break;
        }

        case 3: {
            attributes.rightSeparatorLineInsets = UIEdgeInsetsMake(0, 0, 20, 0);
            break;
        }

        case 4: {
            break;
        }
        }
        if (residue == 0) {
            attributes.frame =
                CGRectMake(0, 0, [self itemSize:item].width, [self itemSize:item].height);
        } else {
            attributes.frame = CGRectMake([self itemSize:0].width +
                                              ((residue % 2) ? 0 : [self itemSize:item - 1].width),
                                          (residue > 2 ? [self itemSize:item].height : 0),
                                          [self itemSize:item].width, [self itemSize:item].height);
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
    CGFloat reactiveWidth = PTRoundPixIntValue(80 * sizeRatio);
    NSArray *sizeMap = @[
        NSStringFromCGSize(CGSizeMake(width - 2 * reactiveWidth - 15, width / 2)),
        NSStringFromCGSize(CGSizeMake(reactiveWidth, reactiveWidth)),
        NSStringFromCGSize(CGSizeMake(reactiveWidth, reactiveWidth)),
        NSStringFromCGSize(CGSizeMake(reactiveWidth, reactiveWidth)),
        NSStringFromCGSize(CGSizeMake(reactiveWidth, reactiveWidth)),
    ];

    item = item % 5;
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
