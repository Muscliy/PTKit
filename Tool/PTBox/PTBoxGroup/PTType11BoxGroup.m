//
//  PTType11BoxGroup.m
//  PTKit
//
//  Created by LeeHu on 14/12/17.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTType11BoxGroup.h"

@implementation PTType11BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE11" ];
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
    CGSize size = CGSizeMake(44,64);
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
                      layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                               inSection:section]];
        attributes.frame = CGRectMake(18 + item * (size.width + 16), 10, size.width, size.height);
        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0 ? size.height+20 : 0;
    return sectionAttributes;
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
