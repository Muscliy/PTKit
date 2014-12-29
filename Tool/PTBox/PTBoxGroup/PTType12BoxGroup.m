//
//  PTType12BoxGroup.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTType12BoxGroup.h"
#import "PTRectMacro.h"
#import "PTColorMacro.h"


@implementation PTType12BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE12" ];
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
        switch (item) {
            case 0: {
                attributes.frame = CGRectMake(10, 0, size.width, size.height);
                attributes.leftSeparatorLineInsets = UIEdgeInsetsZero;
                attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
                break;
            }
            case 1: {
                attributes.frame = CGRectMake(20+[self itemSize:0].width, 0, 160, 75);
                attributes.leftSeparatorLineInsets = UIEdgeInsetsZero;
                attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
                attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
                break;
            }
            case 2: {
                attributes.frame = CGRectMake(20+[self itemSize:0].width, 10+[self itemSize:1].height, 75, 75);
                attributes.leftSeparatorLineInsets = UIEdgeInsetsZero;
                attributes.topSeparatorLineInsets = UIEdgeInsetsZero;
                attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
                break;
            }
            case 3: {
                attributes.frame = CGRectMake(30+[self itemSize:0].width + [self itemSize:2].width, 10+[self itemSize:1].height, 75, 75);
                attributes.leftSeparatorLineInsets = UIEdgeInsetsZero;
                attributes.topSeparatorLineInsets = UIEdgeInsetsZero;
                attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
                break;
            }
                
            default:
                break;
        }
        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0 ? [self itemSize:0].height : 0;
    return sectionAttributes;
}

- (CGSize)itemSize:(NSUInteger)item
{
    NSArray *sizeMap = @[ NSStringFromCGSize(CGSizeMake(130, 160)),
                          NSStringFromCGSize(CGSizeMake(160, 75)),
                          NSStringFromCGSize(CGSizeMake(75, 75)),
                          NSStringFromCGSize(CGSizeMake(75, 75)),
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
    attributes.bgColor = COLOR_SHADE;
    return attributes;
}


@end
