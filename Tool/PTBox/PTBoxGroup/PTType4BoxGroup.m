//
//  PTType4BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType4BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType4BoxGroup

PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
    return @[ @"TYPE4", @"TYPE5", @"TYPE7", @"TYPE15" ];
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
attributesForItemsInSection:(NSInteger)section
                      width:(CGFloat)width
                totalHeight:(CGFloat *)totalHeight
                 dataSource:(id<PTBoxDataSource>)dataSource
                       type:(id)types
{
    BOOL hasTopLine = NO;
    NSArray *showTypes = @[ CC_HOMEPAGEMODULECONSTANT_TYPE8, CC_HOMEPAGEMODULECONSTANT_TYPE9 ];
    
    if (section > 1) {
        NSString *aType = types[section - 1];
        hasTopLine = [showTypes containsObject:aType];
    }
    id type = types[section];
    NSUInteger itemCount = [collectionView numberOfItemsInSection:section];
    NSMutableArray *sectionAttributes = [@[] mutableCopy];
    PTCollectionViewLayoutAttributes *attributes = nil;
    
    SEL selSize =
    NSSelectorFromString([NSString stringWithFormat:@"item%@Size:", (NSString *)type]);
    
    for (NSInteger item = 0; item < itemCount; ++item) {
        attributes = [PTCollectionViewLayoutAttributes
                      layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item
                                                                               inSection:section]];
        if (item % 2 != 1 && ![type isEqualToString:@"TYPE7"]) {
            attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
        }
        NSValue *ret;
        PTPerformSelectorLeakWarning(ret = [self performSelector:selSize withObject:@(item % 2)]);
        NSValue *firstValue;
        PTPerformSelectorLeakWarning(firstValue = [self performSelector:selSize withObject:@(0)]);
        
        CGSize size = [ret CGSizeValue];
        
        CGSize firstSize = [firstValue CGSizeValue];
        
        attributes.frame =
        CGRectMake((item % 2) * (firstSize.width + ([type isEqualToString:@"TYPE7"] ? 10 : 0)),
                   (item / 2) * firstSize.height , size.width, size.height);
        if ([@"TYPE7" isEqualToString:type]) {
            attributes.contentInsets =
            UIEdgeInsetsMake(0, (item % 2) ? (10 * [PTBoxGroup contentScale640]) : 0, 0,
                             (item % 2) ? 0 : (10 * [PTBoxGroup contentScale640]));
        } else {
            if ([@"TYPE15" isEqualToString:type]) {
                if (item == 0) {
                    attributes.rightSeparatorLineInsets = UIEdgeInsetsZero;
                }
            }
            attributes.bottomSeparatorLineInsets = UIEdgeInsetsZero;
            attributes.topSeparatorLineInsets =
            hasTopLine ? UIEdgeInsetsZero : attributes.topSeparatorLineInsets;
        }
        
        [sectionAttributes addObject:attributes];
    }
    
    NSValue *ret;
    PTPerformSelectorLeakWarning(ret = [self performSelector:selSize withObject:@(0)]);
    CGSize size = [ret CGSizeValue];
    *totalHeight = size.height * ((itemCount + 1) / 2);
    return sectionAttributes;
}

- (NSValue *)itemTYPE4Size:(NSNumber *)num
{
    NSUInteger item = [num integerValue];
    NSArray *sizeMap = @[
                         NSStringFromCGSize(CGSizeMake(320 - PTRoundPixelValue(320 / 3), 100)),
                         NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3), 100)),
                         ];
    
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)itemTYPE5Size:(NSNumber *)num
{
    NSUInteger item = [num integerValue];
    NSArray *sizeMap = @[
                         NSStringFromCGSize(CGSizeMake(PTRoundPixelValue(320 / 3), 100)),
                         NSStringFromCGSize(CGSizeMake(320 - PTRoundPixelValue(320 / 3), 100)),
                         ];
    
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)itemTYPE7Size:(NSNumber *)num
{
    NSUInteger item = [num integerValue];
    NSArray *sizeMap =
    @[ NSStringFromCGSize(CGSizeMake(145, 80)), NSStringFromCGSize(CGSizeMake(145, 80)), ];
    
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}

- (NSValue *)itemTYPE15Size:(NSNumber *)num
{
    NSUInteger item = [num integerValue];
    NSArray *sizeMap = @[
                         NSStringFromCGSize(CGSizeMake(320 / 2, 64)),
                         NSStringFromCGSize(CGSizeMake(320 / 2, 64)),
                         ];
    
    NSString *str = sizeMap[item];
    CGSize size = CGSizeFromString(str);
    NSValue *value = [NSValue valueWithCGSize:size];
    return value;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    CGFloat sizeRatio = [PTBoxGroup contentScale640];
    if ([type isEqualToString:@"TYPE7"]) {
        return UIEdgeInsetsMake(0, 20 * sizeRatio, 0, 20 * sizeRatio);
    }
    
    return UIEdgeInsetsZero;
}

@end
