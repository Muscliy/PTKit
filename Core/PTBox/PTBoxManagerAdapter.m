//
//  PTBoxManagerAdapter.m
//  xmLife
//
//  Created by weihuazhang on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTBoxManagerAdapter.h"
#import "PTBoxManager.h"
#import "NimbusCollections.h"

@implementation PTBoxManagerAdapter

- (NSArray *)collectionView:(UICollectionView *)collectionView
                         layout:(PTCollectionViewLayout *)layout
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
{
    id type = [self.types objectAtIndex:section];
    PTBoxGroup *layoutBoxGroup = [[PTBoxManager sharedInstance] boxGroupForType:type];
    return [layoutBoxGroup collectionView:collectionView
              attributesForItemsInSection:section
                                    width:width
                              totalHeight:totalHeight
                               dataSource:self.dataSource
                                     type:self.types];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(PTCollectionViewLayout *)layout
        insetForSectionAtIndex:(NSInteger)section
{
    id type = [self.types objectAtIndex:section];
    PTBoxGroup *layoutBoxGroup = [[PTBoxManager sharedInstance] boxGroupForType:type];
    return [layoutBoxGroup collectionView:collectionView
                   insetForSectionAtIndex:section
                               dataSource:self.dataSource
                                     type:type];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                           layout:(PTCollectionViewLayout *)layout
    outsideInsetForSectionAtIndex:(NSInteger)section
{
    id type = [self.types objectAtIndex:section];
    PTBoxGroup *layoutBoxGroup = [[PTBoxManager sharedInstance] boxGroupForType:type];
    return [layoutBoxGroup collectionView:collectionView
            outsideInsetForSectionAtIndex:section
                               dataSource:self.dataSource
                                     type:type];
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                                              layout:(PTCollectionViewLayout *)layout
                         attributeForHeaderInSection:(NSInteger)section
                                               width:(CGFloat)width
{
    id type = [self.types objectAtIndex:section];
    PTBoxGroup *layoutBoxGroup = [[PTBoxManager sharedInstance] boxGroupForType:type];
    return [layoutBoxGroup collectionView:collectionView
              attributeForHeaderInSection:section
                                    width:width
                               dataSource:self.dataSource
                                     type:type];
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                                              layout:(PTCollectionViewLayout *)layout
                         attributeForFooterInSection:(NSInteger)section
                                               width:(CGFloat)width
{
    id type = [self.types objectAtIndex:section];
    PTBoxGroup *layoutBoxGroup = [[PTBoxManager sharedInstance] boxGroupForType:type];
    return [layoutBoxGroup collectionView:collectionView
              attributeForFooterInSection:section
                                    width:width
                               dataSource:self.dataSource
                                     type:type];
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                                              layout:(PTCollectionViewLayout *)layout
                 attributeForDecorationViewInSection:(NSInteger)section
                                                size:(CGSize)size
{
    id type = [self.types objectAtIndex:section];
    PTBoxGroup *layoutBoxGroup = [[PTBoxManager sharedInstance] boxGroupForType:type];
    return [layoutBoxGroup collectionView:collectionView
        attributeForDecorationViewInSection:section
                                       size:size
                                 dataSource:self.dataSource
                                       type:self.types];
}

@end
