//
//  PTBoxGroup.m
//  xmLife
//
//  Created by weihuazhang on 14/10/31.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTBoxGroup.h"
#import "PTBoxManager.h"

static CGFloat s_contentScale640 = 0.5;
static CGFloat s_contentScale320 = 1.0;
static BOOL s_hasInitContentScale = NO;

@implementation PTBoxGroup

+ (void)commonLoad
{
    @autoreleasepool
    {
        if ([[self sharedInstance] needRegisterToManager]) {
            [[PTBoxManager sharedInstance] registerBoxGroup:[self sharedInstance]
                                                    forType:[self allRegisterGroupType]];
        }
    }
}

+ (instancetype)sharedInstance
{
    NSAssert(NO, @"%@需要实现sharedInstance, 在.m添加‘PTBoxCommonImplementation’",
             NSStringFromClass([self class]));
    return nil;
}

+ (void)computContentScale
{
    if (!s_hasInitContentScale) {
        s_hasInitContentScale = YES;

        s_contentScale320 = [UIScreen mainScreen].bounds.size.width / 320.0;
        s_contentScale640 = [UIScreen mainScreen].bounds.size.width / 640.0;
    }
}

+ (CGFloat)contentScale320
{
    return s_contentScale320;
}

+ (CGFloat)contentScale640
{
    return s_contentScale640;
}

- (CGRect)converScale640Rect:(CGRect)rect
{
    rect.origin.x *= s_contentScale640;
    rect.origin.y *= s_contentScale640;
    rect.size.width *= s_contentScale640;
    rect.size.height *= s_contentScale640;
    return rect;
}

- (CGRect)converScale320Rect:(CGRect)rect
{
    rect.origin.x *= s_contentScale320;
    rect.origin.y *= s_contentScale320;
    rect.size.width *= s_contentScale320;
    rect.size.height *= s_contentScale320;
    return rect;
}

+ (NSArray *)allRegisterGroupType
{
    NSMutableArray *allTypes = [NSMutableArray arrayWithArray:[self extraRegisterGroupType]];
    if ([self registerGroupType]) {
        [allTypes addObject:[self registerGroupType]];
    }

    return allTypes;
}

+ (id)registerGroupType
{
    return [self class];
}

+ (NSArray *)extraRegisterGroupType
{
    return nil;
}

- (BOOL)needRegisterToManager
{
    return YES;
}

- (NSArray *)collectionView:(UICollectionView *)collectionView
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
                     dataSource:(id<PTBoxDataSource>)dataSource
                           type:(id)type
{
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type
{
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
    outsideInsetForSectionAtIndex:(NSInteger)section
                       dataSource:(id<PTBoxDataSource>)dataSource
                             type:(id)type
{
    return UIEdgeInsetsZero;
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                         attributeForHeaderInSection:(NSInteger)section
                                               width:(CGFloat)width
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)type
{
    return nil;
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                         attributeForFooterInSection:(NSInteger)section
                                               width:(CGFloat)width
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)type
{
    return nil;
}

- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                 attributeForDecorationViewInSection:(NSInteger)section
                                                size:(CGSize)size
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)type
{
    return nil;
}

@end
