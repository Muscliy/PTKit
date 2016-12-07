//
//  PTType16BoxGroup.m
//  xmLife
//
//  Created by Chen.Cui on 3/26/15.
//  Copyright (c) 2015 PaiTao. All rights reserved.
//

#import "PTType16BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType16BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE16 ];
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
        attributes.frame = [self itemFrame:item itemCount:itemCount];

        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0 ? [self getItemHieght:itemCount] + 0.5 : 0;
    return sectionAttributes;
}

- (CGRect)itemFrame:(NSUInteger)item itemCount:(NSInteger)itemCount
{
    NSArray *rectMap = [self getItemRectArrayMap:itemCount];
    NSString *str = rectMap[item % itemCount];
    CGRect frame = CGRectFromString(str);
    return frame;
}

static NSMutableDictionary *itemRectArrayMap = nil;

- (NSArray *)getItemRectArrayMap:(NSInteger)itemCount
{
    if (itemCount == 0) {
        return nil;
    }
    if (!itemRectArrayMap) {
        itemRectArrayMap = [@{} mutableCopy];
    }
    NSArray *itemRectArray = [itemRectArrayMap valueForKey:[@(itemCount) stringValue]];
    if (itemRectArray)
        return itemRectArray;

    CGFloat boundWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat itemWith = PTRoundPixelValue(boundWidth / itemCount);
    CGFloat itemHeight = [self getItemHieght:itemCount];
    CGFloat padWidth = boundWidth - itemCount * itemWith;
    NSInteger padItem = itemCount / 2;
    CGFloat itemX = 0;
    CGFloat itemY = 0;

    NSMutableArray *rectMap = [@[] mutableCopy];

    for (NSInteger i = 0; i < itemCount; i++) {

        if (i == padItem) {
            [rectMap addObject:NSStringFromCGRect(
                                   CGRectMake(itemX, itemY, itemWith + padWidth, itemHeight))];
            itemX += itemWith + padItem;
        } else {
            [rectMap addObject:NSStringFromCGRect(CGRectMake(itemX, itemY, itemWith, itemHeight))];
            itemX += itemWith;
        }
    }

    [itemRectArrayMap setValue:rectMap forKey:[@(itemCount) stringValue]];

    return rectMap;
}

- (CGFloat)getItemHieght:(NSInteger)itemCount
{
    static CGFloat itemHeight = 0;
    if (itemHeight == 0) {
        itemHeight = PTRoundPixelSacle320Value(112 / 2);
    }
    return itemHeight;
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
    attributes.bgColor = [UIColor whiteColor];
    attributes.hasBottomLine = YES;
    attributes.hasTopLine = hasTopLine;
    attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
    return attributes;
}
@end
