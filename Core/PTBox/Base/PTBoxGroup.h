//
//  PTBoxGroup.h
//  xmLife
//
//  Created by weihuazhang on 14/10/31.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTBox.h"
#import "PTCollectionViewLayoutAttributes.h"
#import "PTCollectionViewLayout.h"
#import "HomePageModuleConstant.h"

/**
 *			使用说明
 *1.PTBoxGroup子类需要在.m实现类中加上 PTBoxCommonImplementation
        用于调用将需要处理的大积木加入到PTBoxManagermanager
 *2.子类需要重载+ (NSArray *)extraRegisterGroupType返回需要处理的类型type数组
 **/

@protocol PTBoxDataSource <NSObject>

@optional

- (CGSize)collectionView:(UICollectionView *)collectionView
    referenceSizeForHeaderInSection:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView
    referenceSizeForFooterInSection:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
               insetForSection:(NSInteger)section;
@end

@protocol PTBoxGroupLayout <NSObject>

@optional
- (NSArray *)collectionView:(UICollectionView *)collectionView
    attributesForItemsInSection:(NSInteger)section
                          width:(CGFloat)width
                    totalHeight:(CGFloat *)totalHeight
                     dataSource:(id<PTBoxDataSource>)dataSource
                           type:(id)type;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
        insetForSectionAtIndex:(NSInteger)section
                    dataSource:(id<PTBoxDataSource>)dataSource
                          type:(id)type;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
    outsideInsetForSectionAtIndex:(NSInteger)section
                       dataSource:(id<PTBoxDataSource>)dataSource
                             type:(id)type;
- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                         attributeForHeaderInSection:(NSInteger)section
                                               width:(CGFloat)width
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)type;
- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                         attributeForFooterInSection:(NSInteger)section
                                               width:(CGFloat)width
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)type;
- (UICollectionViewLayoutAttributes *)collectionView:(UICollectionView *)collectionView
                 attributeForDecorationViewInSection:(NSInteger)section
                                                size:(CGSize)size
                                          dataSource:(id<PTBoxDataSource>)dataSource
                                                type:(id)type;

@end

@interface PTBoxGroup : NSObject <PTBoxGroupLayout>

+ (void)commonLoad;
+ (instancetype)sharedInstance;
+ (void)computContentScale;
+ (CGFloat)contentScale320;
+ (CGFloat)contentScale640;

//以下两个方法默认不需要重载
- (BOOL)needRegisterToManager; // Default = YES;
+ (id)registerGroupType;       // Default = [self class];
- (CGRect)converScale640Rect:(CGRect)rect;
- (CGRect)converScale320Rect:(CGRect)rect;

//override:返回对应注册的类型数组
+ (NSArray *)extraRegisterGroupType;

@end
