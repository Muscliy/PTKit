//
//  PTType17BoxGroup.m
//  xmLife
//
//  Created by Chen.Cui on 3/26/15.
//  Copyright (c) 2015 PaiTao. All rights reserved.
//

#import "PTType17BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType17BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ CC_HOMEPAGEMODULECONSTANT_TYPE17 ];
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
        attributes.frame = [self itemFrame:item itemCount:itemCount width:width];

        [sectionAttributes addObject:attributes];
    }
    *totalHeight = itemCount > 0 ? [self getItemHieght:itemCount] : 0;
    return sectionAttributes;
}

- (CGRect)itemFrame:(NSUInteger)item itemCount:(NSInteger)itemCount width:(CGFloat)width
{
    NSArray *rectMap = [self getItemRectArrayMap:itemCount width:width];
    NSString *str = rectMap[item % itemCount];
    CGRect frame = CGRectFromString(str);
    return frame;
}

static NSMutableDictionary *itemRectArrayMap = nil;

- (NSArray *)getItemRectArrayMap:(NSInteger)itemCount width:(CGFloat)width
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

    CGFloat boundWidth = width - (itemCount - 1) * [self getcolumnSpace];
    CGFloat itemWith = PTRoundPixelValue(boundWidth / itemCount);
    CGFloat itemHeight = [self getItemHieght:itemCount];
    CGFloat padWidth = boundWidth - itemCount * itemWith;
    NSInteger padItem = itemCount / 2;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat coloumWidth = [self getcolumnSpace];

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
        itemX += coloumWidth;
    }

    [itemRectArrayMap setValue:rectMap forKey:[@(itemCount) stringValue]];

    return rectMap;
}

- (CGFloat)getItemHieght:(NSInteger)itemCount
{
    static CGFloat itemHeight = 0;
    if (itemHeight == 0) {
        itemHeight = PTRoundPixelSacle640Value(64);
    }
    return itemHeight;
}

- (CGFloat)getcolumnSpace
{
    return PTRoundPixelSacle640Value(12);
}

// there is anther way : through delegate handled by viewcontroller
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)types
{
    UIEdgeInsets inset =
        UIEdgeInsetsMake(PTRoundPixelSacle640Value(20), PTRoundPixelSacle640Value(30),
                         PTRoundPixelSacle640Value(20), PTRoundPixelSacle640Value(30));

    if ([dataSource respondsToSelector:@selector(collectionView:insetForSection:)]) {
        inset = [dataSource collectionView:collectionView insetForSection:section];
    }

    return inset;
}

// there is anther way : through delegate handled by viewcontroller
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

    NSArray *sectionArray = (NSArray *)types;

    NSString *nextType =
        ((section + 1) <= sectionArray.count - 1) ? sectionArray[section + 1] : nil;
    BOOL hasBottomLine = [nextType isEqualToString:CC_HOMEPAGEMODULECONSTANT_TYPE17] ? NO : YES;

    PTCollectionViewLayoutAttributes *attributes = [PTCollectionViewLayoutAttributes
        layoutAttributesForDecorationViewOfKind:PTCollectionViewLayoutKindBoxGroupBg
                                  withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    attributes.frame = CGRectMake(0, 0, size.width, size.height);
    attributes.bgColor = [UIColor whiteColor];
    attributes.hasBottomLine = hasBottomLine;
    attributes.hasTopLine = hasTopLine;
    attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
    return attributes;
}

@end
