//
//  PTType14BoxGroup.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTType14BoxGroup.h"
#import "PTRectMacro.h"

@implementation PTType14BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE14"];
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
        CGSize size = [self itemSize:item];
        if (item < 2) {
            attributes.frame = CGRectMake(0, item > 0 ? size.height : 0, size.width, size.height);
        } else
        {
            CGFloat originX = [self itemSize:0].width;
            NSUInteger row = item - 2;
            attributes.frame = CGRectMake((row % 2) * (size.width + 10) + originX,  10 + (row / 2) * (size.height + 10), size.width, size.height);
        }
        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0 ? [self itemSize:0].height + [self itemSize:1].height : 0;
    return sectionAttributes;
}

- (CGSize)itemSize:(NSUInteger)item
{
    NSArray *sizeMap = @[ NSStringFromCGSize(CGSizeMake(148, 74)),
                          NSStringFromCGSize(CGSizeMake(148, 74)),
                          NSStringFromCGSize(CGSizeMake(75, 36)),
                          NSStringFromCGSize(CGSizeMake(75, 36)),
                          NSStringFromCGSize(CGSizeMake(75, 36)),
                          NSStringFromCGSize(CGSizeMake(75, 36)),
                          NSStringFromCGSize(CGSizeMake(75, 36)),
                          NSStringFromCGSize(CGSizeMake(75, 36)),
                          ];
    
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
    
    PTCollectionViewLayoutAttributes *attributes = [PTCollectionViewLayoutAttributes
                                                    layoutAttributesForDecorationViewOfKind:PTCollectionViewLayoutKindBoxGroupBg
                                                    withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    attributes.frame = CGRectMake(0, 0, size.width, size.height);
    attributes.bgColor = [UIColor whiteColor];
    return attributes;
}




@end
