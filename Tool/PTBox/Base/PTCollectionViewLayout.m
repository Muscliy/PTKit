//
//  PTCollectionViewLayout.m
//  xmLife
//
//  Created by weihuazhang on 14/10/28.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTCollectionViewLayout.h"
#import "PTBoxGroup.h"

NSString *const PTCollectionViewLayoutKindBoxGroupBg = @"PTCollectionViewLayoutKindBoxGroupBg";
NSString *const PTCollectionViewLayoutKindBoxGroupHeader =
    @"PTCollectionViewLayoutKindBoxGroupHeader";
NSString *const PTCollectionViewLayoutKindBoxGroupFooter =
    @"PTCollectionViewLayoutKindBoxGroupFooter";

@interface UICollectionView (headerFooter)
@property (nonatomic, strong) UIView *collectionHeaderView;
@property (nonatomic, strong) UIView *collectionFooterView;
@end

@interface PTCollectionViewLayout ()

@property (nonatomic, assign) CGSize layoutContentSize;

// Array to store union rectangles
@property (nonatomic, strong) NSMutableArray *sectionUnionRects;

@end

@implementation PTCollectionViewLayout

+ (void)initialize
{
    [PTBoxGroup computContentScale];
}

+ (Class)layoutAttributesClass
{
    return [PTCollectionViewLayoutAttributes class];
}

- (instancetype)init
{
    if ((self = [super init])) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    _collectionViewInset = UIEdgeInsetsZero;
}

- (void)clearLayout
{
    self.sectionItemAttributes = [@[] mutableCopy];
	self.secionHeaderAttributes = [@{} mutableCopy];
	self.secionFotterAttributes = [@{} mutableCopy];
	self.sectionDecorationAttributes = [@{} mutableCopy];
    self.sectionUnionRects = [@[] mutableCopy];

    _layoutContentSize = CGSizeZero;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
    // return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

- (void)invalidateLayout
{
    [super invalidateLayout];
}

- (void)prepareLayout
{
    // step1
    [super prepareLayout];
    [self clearLayout];

    CGRect collectionFrame = self.collectionView.frame;
    _layoutContentSize = CGSizeMake(collectionFrame.size.width, 0);
    CGFloat contentWidth_ =
        collectionFrame.size.width - _collectionViewInset.left - _collectionViewInset.right;
    CGPoint offset_;
    offset_.x = _collectionViewInset.left;
    offset_.y = _collectionViewInset.top;

    // layout collection header
    if ([self.collectionView respondsToSelector:@selector(collectionHeaderView)]) {
        UIView *headerView = [self.collectionView collectionHeaderView];
        CGRect headerRect = headerView.frame;
        headerRect.origin.x = offset_.x;
        headerRect.origin.y = offset_.y;
        headerRect.size.width = contentWidth_;
        headerView.frame = headerRect;
        offset_.y += headerRect.size.height;
    }

    // layout section items
    {
        BOOL isImplementAttributesForElement = [self.delegate
            respondsToSelector:
                @selector(collectionView:layout:attributesForItemsInSection:width:totalHeight:)];
        BOOL isImplementInsetForSection = [self.delegate
            respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)];
        BOOL isImplementAttributesForHeader = [self.delegate
            respondsToSelector:@selector(collectionView:layout:attributeForHeaderInSection:width:)];
        BOOL isImplementAttributesForFooter = [self.delegate
            respondsToSelector:@selector(collectionView:layout:attributeForFooterInSection:width:)];
        BOOL isImplementOutsideInsetForSection = [self.delegate
            respondsToSelector:@selector(collectionView:layout:outsideInsetForSectionAtIndex:)];
        BOOL isImplementDecorationForSection =
            [self.delegate respondsToSelector:@selector(collectionView:layout:
                                                  attributeForDecorationViewInSection:
                                                                                 size:)];

        NSInteger numSections = self.numberOfSections;
        for (NSInteger section = 0; section < numSections; section++) {
            // get seciton outSide edgeInsets

            UIEdgeInsets sectionOutsideInsets = UIEdgeInsetsZero;
            if (isImplementOutsideInsetForSection) {
                sectionOutsideInsets = [self.delegate collectionView:self.collectionView
                                                              layout:self
                                       outsideInsetForSectionAtIndex:section];
            }

            CGFloat sectionStartY = offset_.y + sectionOutsideInsets.top;
            CGPoint sectionOffset =
                CGPointMake(offset_.x + sectionOutsideInsets.left, sectionStartY);
            CGFloat sectionWidth =
                contentWidth_ - sectionOutsideInsets.left - sectionOutsideInsets.right;

            // layout section header
            if (isImplementAttributesForHeader) {
                UICollectionViewLayoutAttributes *headerAttributes =
                    [self.delegate collectionView:self.collectionView
                                             layout:self
                        attributeForHeaderInSection:section
                                              width:sectionWidth];
                if (headerAttributes) {
                    NSAssert(
                        headerAttributes.representedElementCategory ==
                            UICollectionElementCategorySupplementaryView,
                        @"headerAttributes类别应该为UICollectionElementCategorySupplementaryView");
                    [headerAttributes offset:sectionOffset];
                    self.secionHeaderAttributes[headerAttributes.indexPath] = headerAttributes;
                    sectionOffset.y += headerAttributes.size.height;
                }
            }

            // get seciton inSide edgeInsets
            UIEdgeInsets sectionInsideInsets = UIEdgeInsetsZero;
            if (isImplementInsetForSection) {
                sectionInsideInsets = [self.delegate collectionView:self.collectionView
                                                             layout:self
                                             insetForSectionAtIndex:section];
            }

            CGPoint itemOffset = CGPointMake(sectionOffset.x + sectionInsideInsets.left,
                                             sectionOffset.y + sectionInsideInsets.top);
            CGFloat itemWidth = sectionWidth - sectionInsideInsets.left - sectionInsideInsets.right;

            // layout section
            // items====================================================================
            CGFloat sectionItemTotalHeight = 0;
            NSArray *sectionItems = nil;
            if (isImplementAttributesForElement) {
                sectionItems = [self.delegate collectionView:self.collectionView
                                                      layout:self
                                 attributesForItemsInSection:section
                                                       width:itemWidth
                                                 totalHeight:&sectionItemTotalHeight];
            }
            if (sectionItems == nil) {
                sectionItems = @[];
            }

            for (UICollectionViewLayoutAttributes *itemAttributes in sectionItems) {
                [itemAttributes offset:itemOffset];
            }

            [self.sectionItemAttributes addObject:sectionItems];
            sectionOffset.y = itemOffset.y + sectionItemTotalHeight + sectionInsideInsets.bottom;
            // end layout section
            // items====================================================================

            // layout section footer
            if (isImplementAttributesForFooter) {
                UICollectionViewLayoutAttributes *footerAttributes =
                    [self.delegate collectionView:self.collectionView
                                             layout:self
                        attributeForFooterInSection:section
                                              width:sectionWidth];
                if (footerAttributes) {
                    NSAssert(
                        footerAttributes.representedElementCategory ==
                            UICollectionElementCategorySupplementaryView,
                        @"footerAttributes类别应该为UICollectionElementCategorySupplementaryView");
                    [footerAttributes offset:sectionOffset];
                    self.secionFotterAttributes[footerAttributes.indexPath] = footerAttributes;
                    sectionOffset.y += footerAttributes.size.height;
                }
            }

            CGRect sectionRect = CGRectMake(sectionOffset.x, sectionStartY, sectionWidth,
                                            sectionOffset.y - sectionStartY);
            [self.sectionUnionRects addObject:[NSValue valueWithCGRect:sectionRect]];

            //修饰layout section decoration
            if (isImplementDecorationForSection) {
                UICollectionViewLayoutAttributes *decorationViewAttribute =
                    [self.delegate collectionView:self.collectionView
                                                     layout:self
                        attributeForDecorationViewInSection:section
                                                       size:sectionRect.size];
                if (decorationViewAttribute) {
                    [decorationViewAttribute offset:sectionRect.origin];
                    self.sectionDecorationAttributes[decorationViewAttribute.indexPath] =
                        decorationViewAttribute;
                }
            }

            sectionOffset.y += sectionOutsideInsets.bottom;
            offset_.y = sectionOffset.y;
        }
    }

    // layout collection footer
    if ([self.collectionView respondsToSelector:@selector(collectionFooterView)]) {
        UIView *footerView = [self.collectionView collectionFooterView];
        CGRect footerRect = footerView.frame;
        footerRect.origin.x = offset_.x;
        footerRect.origin.y = offset_.y;
        footerRect.size.width = contentWidth_;
        footerView.frame = footerRect;
        offset_.y += footerRect.size.height;
    }

    offset_.y += _collectionViewInset.bottom;
    _layoutContentSize.height = offset_.y;
}

- (CGSize)collectionViewContentSize
{
    // step2
    return _layoutContentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // step3
    NSMutableArray *retAttributes = [@[] mutableCopy];

    NSInteger numSections = self.numberOfSections;
    CGFloat rectTop = CGRectGetMinY(rect);
    CGFloat rectBottom = CGRectGetMaxY(rect);
    for (NSInteger section = 0; section < numSections; section++) {
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        //判断section在不在显示区域内
        CGRect sectionRect = [self.sectionUnionRects[section] CGRectValue];
        //这里不用CGRectIntersectsRect来判断
        if (CGRectGetMinY(sectionRect) > rectBottom) {
            break;
        }
        if (CGRectGetMaxY(sectionRect) < rectTop) {
            continue;
        }

        // section Header
        UICollectionViewLayoutAttributes *sectionHeader =
            self.secionHeaderAttributes[sectionIndexPath];
        if (sectionHeader) {
            if (CGRectIntersectsRect(rect, sectionHeader.frame)) {
                [retAttributes addObject:sectionHeader];
            }
        }

        // section Items

        NSArray *sectionItems = self.sectionItemAttributes[section];
        for (UICollectionViewLayoutAttributes *sectionItem in sectionItems) {
            if (CGRectIntersectsRect(rect, sectionItem.frame)) {
                [retAttributes addObject:sectionItem];
            }
        }

        // section Footer
        UICollectionViewLayoutAttributes *sectionFooter =
            self.secionFotterAttributes[sectionIndexPath];
        if (sectionFooter) {
            if (CGRectIntersectsRect(rect, sectionFooter.frame)) {
                [retAttributes addObject:sectionFooter];
            }
        }

        // section Decoration
        UICollectionViewLayoutAttributes *sectionDecoration =
            self.sectionDecorationAttributes[sectionIndexPath];
        if (sectionDecoration) {
            if (CGRectIntersectsRect(rect, sectionDecoration.frame)) {
                [retAttributes addObject:sectionDecoration];
            }
        }
    }

    return retAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.sectionItemAttributes[indexPath.section][indexPath.row];
}

- (UICollectionViewLayoutAttributes *)
    layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                   atIndexPath:(NSIndexPath *)indexPath
{
    if (elementKind == PTCollectionViewLayoutKindBoxGroupHeader) {
        return self.secionHeaderAttributes[indexPath];
    } else if (elementKind == PTCollectionViewLayoutKindBoxGroupFooter) {
        return self.secionFotterAttributes[indexPath];
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)
    layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
                                atIndexPath:(NSIndexPath *)indexPath
{
    return self.sectionDecorationAttributes[indexPath];
}

- (NSInteger)numberOfSections
{
    return [self.collectionView numberOfSections];
}

- (void)setcollectionViewInset:(UIEdgeInsets)collectionViewInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_collectionViewInset, collectionViewInset)) {
        _collectionViewInset = collectionViewInset;
        [self invalidateLayout];
    }
}

@end
