//
//  PTPagerTabStripButtonBarView.m
//  PTKit
//
//  Created by LeeHu on 5/7/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTPagerTabStripButtonBarView.h"
#import "PTOSMacro.h"

@interface PTPagerTabStripButtonBarView ()

@property (nonatomic, strong) UIView *selectedBar;
@property (nonatomic, assign) NSUInteger selectedOptionIndex;

@end

@implementation PTPagerTabStripButtonBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self initializeView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if ((self = [super initWithFrame:frame collectionViewLayout:layout])) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView
{
    _selectedOptionIndex = 0;
    if ([self.selectedBar superview] == nil) {
        [self addSubview:self.selectedBar];
    }
}

- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated swipeDirection:(PTPagerTabStripDirection)swiperDirection
{
    self.selectedOptionIndex = index;
    [self updateSelectedBarPositionWithAnimation:animated swipeDirection:swiperDirection];
}

- (void)moveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withProgressPercentage:(CGFloat)progressPercenttage
{
    self.selectedOptionIndex = (progressPercenttage > 0.5) ? toIndex : fromIndex;
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0]];
    CGRect fromFrame = attributes.frame;
    NSInteger numberOfItems = [self.dataSource collectionView:self numberOfItemsInSection:0];
    CGRect toFrame;
    if (toIndex < 0 || toIndex > numberOfItems - 1) {
        if (toIndex < 0) {
            UICollectionViewLayoutAttributes *cellAtts = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
            toFrame = CGRectOffset(cellAtts.frame, -cellAtts.frame.size.width, 0);
        } else {
            UICollectionViewLayoutAttributes *cellAtts = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:(numberOfItems - 1) inSection:0]];
            toFrame = CGRectOffset(cellAtts.frame, cellAtts.frame.size.width, 0);
        }
    } else {
        toFrame = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]].frame;
    }
    
    CGRect targetFrame = fromFrame;
    targetFrame.size.height = self.selectedBar.frame.size.height;
    targetFrame.size.width += (toFrame.size.width - fromFrame.size.width) * progressPercenttage;
    targetFrame.origin.x += (toFrame.origin.x - fromFrame.origin.x) * progressPercenttage;
    
    NSUInteger offset = 35;
    float xValue = 0;
    if (self.contentSize.width > self.frame.size.width) {
        xValue = MIN(self.contentSize.width - self.frame.size.width, targetFrame.origin.x - offset <= 0 ? 0 : targetFrame.origin.x - offset);
    }
    
    [self setContentOffset:CGPointMake(xValue, 0) animated:NO];
    self.selectedBar.frame = CGRectMake(targetFrame.origin.x, self.selectedBar.frame.origin.y, targetFrame.size.width, self.selectedBar.frame.size.height);
}


- (void)updateSelectedBarPositionWithAnimation:(BOOL)animation swipeDirection:(PTPagerTabStripDirection)swipeDirection
{
    CGRect frame = self.selectedBar.frame;
    UICollectionViewCell *cell = [self.dataSource collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedOptionIndex inSection:0]];
    [self updateContentOffset];
    frame.size.width = cell.frame.size.width;
    frame.origin.x = cell.frame.origin.x;
    if (animation) {
        PTWeakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            PTStrongSelf;
            [self.selectedBar setFrame:frame];
        }];
    } else {
        self.selectedBar.frame = frame;
    }
}

- (void)updateContentOffset
{
    UICollectionViewCell *cell = [self.dataSource collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedOptionIndex inSection:0]];
    if (cell) {
        NSUInteger offset = 35;
        float xValue = MIN(MAX(0, self.contentSize.width - self.frame.size.width), MAX(((UICollectionViewFlowLayout *)self.collectionViewLayout).sectionInset.left - cell.frame.origin.x, cell.frame.origin.x - ((UICollectionViewFlowLayout *)self.collectionViewLayout).sectionInset.left - offset));
        [self setContentOffset:CGPointMake(xValue, 0) animated:YES];
    }
}


- (UIView *)selectedBar
{
    if (_selectedBar) {
        return _selectedBar;
    }
    _selectedBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 5, self.frame.size.width, 5)];
    _selectedBar.layer.zPosition = 9999;
    _selectedBar.backgroundColor = [UIColor blackColor];
    return _selectedBar;
}

@end
