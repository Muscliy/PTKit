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

@implementation PTType6BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE6", @"TYPE8", @"TYPE9" ];
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
    SEL selSize =
        NSSelectorFromString([NSString stringWithFormat:@"item%@Size:", (NSString *)type]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSValue *ret = [self performSelector:selSize];
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

- (NSValue *)itemTYPE6Size:(NSUInteger)item
{
    item = 0;
    NSArray *sizeMap = @[ NSStringFromCGSize(CGSizeMake(600, 160)), ];

    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    size.width = size.width * sizeRatio;
    size.height = size.height * sizeRatio;
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)itemTYPE8Size:(NSUInteger)item
{
    item = 0;
    NSArray *sizeMap = @[ NSStringFromCGSize(CGSizeMake(640, 40)), ];

    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    size.width = size.width * sizeRatio;
    size.height = size.height * sizeRatio;
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)itemTYPE9Size:(NSUInteger)item
{
    item = 0;
    NSArray *sizeMap = @[ NSStringFromCGSize(CGSizeMake(640, 20)), ];

    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    item = item % 3;
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    size.width = size.width * sizeRatio;
    size.height = size.height * sizeRatio;
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    if ([type isEqualToString:@"TYPE6"]) {
        return UIEdgeInsetsMake(0, 20 * sizeRatio, 0, 20 * sizeRatio);
    }
    return UIEdgeInsetsZero;
}

@end
