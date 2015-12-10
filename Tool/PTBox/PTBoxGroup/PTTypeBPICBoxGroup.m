//
//  PTTypeBPICBoxGroup.m
//  xmLife
//
//  Created by Chen.Cui on 3/26/15.
//  Copyright (c) 2015 PaiTao. All rights reserved.
//

#import "PTTypeBPICBoxGroup.h"
#import "PTUIMathUtilities.h"


#define CC_HOMEPAGEMODULECONSTANT_TYPE_EXTRA_BPIC @"TYPE_EXTRA_BPIC"


@implementation PTTypeBPICBoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE_EXTRA_BPIC, CC_HOMEPAGEMODULECONSTANT_DM ];
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
                     dataSource:(id<PTBoxDataSource>)dataSource
                           type:(id)types
{

    id type = types[section];
    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    NSMutableArray *sectionAttributes = [@[] mutableCopy];
    PTCollectionViewLayoutAttributes *attributes = nil;
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
            layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                     inSection:section]];

        attributes.frame =
            ([type isEqualToString:CC_HOMEPAGEMODULECONSTANT_TYPE_EXTRA_BPIC])
                ? CGRectMake(0, 0, width, (43.5))
                : CGRectMake(0, 0, width, PTRoundPixelValue((168 / 2.0) * (width / 320)));

        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0
                       ? ([type isEqualToString:CC_HOMEPAGEMODULECONSTANT_TYPE_EXTRA_BPIC])
                             ? ((43.5) + 0.5)
                             : (PTRoundPixelValue((168 / 2.0) * (width / 320)) + 0.5)
                       : 0;
    return sectionAttributes;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    if ([type isEqualToString:CC_HOMEPAGEMODULECONSTANT_TYPE_EXTRA_BPIC]) {
        return UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return UIEdgeInsetsZero;
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                 attributeForDecorationViewInSection:(NSInteger)section
                                                size:(CGSize)size
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)types
{
    BOOL hasTopLine = NO;
    NSArray *showTypes = @[ CC_HOMEPAGEMODULECONSTANT_TYPE8, CC_HOMEPAGEMODULECONSTANT_TYPE9 ];

    if (section < 2 && section >= 1) {
        NSString *aType = types[section - 1];
        hasTopLine = [showTypes containsObject:aType];
    }

    PTCollectionViewLayoutAttributes *attributes = [PTCollectionViewLayoutAttributes
        layoutAttributesForDecorationViewOfKind:PTCollectionViewLayoutKindBoxGroupBg
                                  withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    attributes.frame = CGRectMake(0, 0, size.width, size.height);
    attributes.bgColor = COLOR_SHADE;
    attributes.hasTopLine = hasTopLine;
    attributes.hasBottomLine = YES;
    return attributes;
}

@end
