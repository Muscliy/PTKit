//
//  PTCollectionViewLayout.h
//  xmLife
//
//  Created by weihuazhang on 14/10/28.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTCollectionViewLayoutAttributes.h"

FOUNDATION_EXPORT NSString *const PTCollectionViewLayoutKindBoxGroupBg;
FOUNDATION_EXPORT NSString *const PTCollectionViewLayoutKindBoxGroupHeader;
FOUNDATION_EXPORT NSString *const PTCollectionViewLayoutKindBoxGroupFooter;

@class PTCollectionViewLayout;

@protocol PTCollectionViewLayoutDelegate <NSObject>

@optional
// return an Arrary of PTCollectionViewLayoutAttributes Class Type
- (NSArray *)collectionView:(UICollectionView *)collectionView
                         layout:(PTCollectionViewLayout *)layout
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(PTCollectionViewLayout *)layout
        insetForSectionAtIndex:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                           layout:(PTCollectionViewLayout *)layout
    outsideInsetForSectionAtIndex:(NSInteger)section;

// layoutAttributesForSupplementaryViewOfKind
- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                                              layout:(PTCollectionViewLayout *)layout
                         attributeForHeaderInSection:(NSInteger)section
                                               width:(CGFloat)width;
- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                                              layout:(PTCollectionViewLayout *)layout
                         attributeForFooterInSection:(NSInteger)section
                                               width:(CGFloat)width;

// layoutAttributesForDecorationViewOfKind
- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                                              layout:(PTCollectionViewLayout *)layout
                 attributeForDecorationViewInSection:(NSInteger)section
                                                size:(CGSize)size;

@end

@interface PTCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<PTCollectionViewLayoutDelegate> delegate;

// Array of arrays. Each array stores item attributes for each section
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;

// Dictionary to store section headers' attribute
@property (nonatomic, strong) NSMutableDictionary *secionHeaderAttributes;
// Dictionary to store section footers' attribute
@property (nonatomic, strong) NSMutableDictionary *secionFotterAttributes;
// Dictionary to store section decoration' attribute
@property (nonatomic, strong) NSMutableDictionary *sectionDecorationAttributes;

@property (nonatomic, readonly) NSInteger numberOfSections;

@property (nonatomic, assign) UIEdgeInsets collectionViewInset;

@end
