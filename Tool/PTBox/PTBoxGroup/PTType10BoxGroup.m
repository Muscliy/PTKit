//
//  PTType10BoxGroup.m
//  xmLife
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTType10BoxGroup.h"
#import "PTUIMathUtilities.h"

@implementation PTType10BoxGroup
PTBoxCommonImplementation;

+ (NSArray *)extraRegisterGroupType
{
	return @[ CC_HOMEPAGEMODULECONSTANT_TYPE10 ];
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
		if (item % 3 != 2) {
			attributes.rightSeparatorLineInsets = UIEdgeInsetsMake(6, 0, 6, 0);
		}
		attributes.frame = CGRectMake(
									  ([self collectionView:collectionView itemSize:0].width) * (item % 3) +
									  ((item % 3 == 2)
									   ? (WIDTH(collectionView) - 3 * PTRoundPixelValue(WIDTH(collectionView) / 3))
									   : 0),
									  0, [self collectionView:collectionView itemSize:item % 3].width,
									  [self collectionView:collectionView itemSize:item % 3].height);
		[sectionAttributes addObject:attributes];
	}
	*totalHeight = itemCount > 0 ? [self collectionView:collectionView itemSize:0].height + 0.5
	: 0; // line height need modify line view
	return sectionAttributes;
}

- (CGSize)collectionView:(UICollectionView *)collectionView itemSize:(NSUInteger)item
{
	
	CGFloat sizeRatio = PTRatio4InchWithCurrentPhoneSize();
	CGSize visibleSize =
	CGSizeMake(collectionView.frame.size.width, PTRoundPixelValue(44 * sizeRatio));
	CGFloat pad = visibleSize.width - 3 * PTRoundPixelValue(visibleSize.width / 3);
	CGFloat itemWidth = PTRoundPixelValue(visibleSize.width / 3);
	
	NSArray *sizeMap = @[
						 NSStringFromCGSize(CGSizeMake(itemWidth, visibleSize.height)),
						 NSStringFromCGSize(CGSizeMake(itemWidth + pad, visibleSize.height)),
						 NSStringFromCGSize(CGSizeMake(itemWidth, visibleSize.height)),
						 ];
	
	item = item % 3;
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
