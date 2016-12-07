//
//  PTType6BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/6.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//
//
//	 ----------------------------------
//
//	   -----------------------------
//	   |							|
//     |							|
//     |			AD				|
//     |							|
//	   ------------------------------
//
//	 ----------------------------------
#import "PTType6BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType6BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[
        CC_HOMEPAGEMODULECONSTANT_TYPE6,
        CC_HOMEPAGEMODULECONSTANT_TYPE8,
        CC_HOMEPAGEMODULECONSTANT_TYPE9
    ];
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
                     dataSource:(id<PTBoxDataSource>)dataSource
                           type:(id)types
{
    id type = types[section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    PTCollectionViewLayoutAttributes *attribute = nil;
    SEL selSize = NSSelectorFromString(
        [NSString stringWithFormat:@"collectionView:item%@Size:", (NSString *)type]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSValue *ret = [self performSelector:selSize withObject:collectionView withObject:nil];
#pragma clang diagnostic pop

    CGSize size = [ret CGSizeValue];

    *totalHeight = size.height;
    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    if (itemCount > 0) {
        attribute =
            [PTCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(0, 0, size.width, size.height);
        return @[ attribute ];
    }

    return nil;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemTYPE6Size:(NSUInteger)item
{
    NSArray *sizeMap =
        @[ NSStringFromCGSize(CGSizeMake(CGRectGetWidth(collectionView.frame) - 20, 80)), ];
    CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();
    NSString *str = [sizeMap firstObject];
    CGSize size = CGSizeFromString(str);
    size.height = PTRoundPixIntValue(size.height * sizeRatio);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemTYPE8Size:(NSUInteger)item
{
    NSArray *sizeMap =
        @[ NSStringFromCGSize(CGSizeMake(CGRectGetWidth(collectionView.frame), 20)), ];
    NSString *str = [sizeMap firstObject];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)collectionView:(UICollectionView *)collectionView itemTYPE9Size:(NSUInteger)item
{
    NSArray *sizeMap =
        @[ NSStringFromCGSize(CGSizeMake(CGRectGetWidth(collectionView.frame), 10)), ];
    NSString *str = [sizeMap firstObject];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    if ([type isEqualToString:CC_HOMEPAGEMODULECONSTANT_TYPE6]) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

@end
