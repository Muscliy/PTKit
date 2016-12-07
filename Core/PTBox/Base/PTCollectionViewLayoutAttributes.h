//
//  PTCollectionViewLayoutAttributes.h
//  xmLife
//
//  Created by weihuazhang on 14/10/31.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewLayoutAttributes (position)

- (void)offset:(CGPoint)offset;

@end

@interface PTCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) UIEdgeInsets leftSeparatorLineInsets;
@property (nonatomic, assign) UIEdgeInsets topSeparatorLineInsets;
@property (nonatomic, assign) UIEdgeInsets rightSeparatorLineInsets;
@property (nonatomic, assign) UIEdgeInsets bottomSeparatorLineInsets;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) BOOL hasBottomLine;
@property (nonatomic, assign) BOOL hasTopLine;
@property (nonatomic, assign) BOOL hasTitle;

@end
