//
//  PTButtonBarPagerTabStripViewController.m
//  PTKit
//
//  Created by LeeHu on 5/7/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTButtonBarPagerTabStripViewController.h"
#import "PTPagerTabStripButtonBarViewCell.h"

NSString *const kButtonBarViewCellIdentifier = @"kButtonBarViewCellIdentifier";

@interface PTButtonBarPagerTabStripViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL shouldUpdateButtonBarView;
@property (nonatomic, strong) PTPagerTabStripButtonBarViewCell *sizeCell;
@property (nonatomic, strong) PTPagerTabStripButtonBarView *buttonBarView;

@end

@implementation PTButtonBarPagerTabStripViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.shouldUpdateButtonBarView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self initInterface];
}

- (void)initInterface
{
     [self.view addSubview:self.buttonBarView];
    
    if (!self.buttonBarView.delegate) {
        self.buttonBarView.delegate = self;
    }
    if (!self.buttonBarView.dataSource) {
        self.buttonBarView.dataSource = self;
    }
    
    self.buttonBarView.lableFont = [UIFont systemFontOfSize:18.0f];
    self.buttonBarView.leftRightMargin = 0;
    [self.buttonBarView setScrollsToTop:NO];

    UICollectionViewFlowLayout * flowLayout = (id)self.buttonBarView.collectionViewLayout;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.buttonBarView setShowsHorizontalScrollIndicator:NO];
    
    CGRect frame = self.containerView.frame;
    frame.origin.y += CGRectGetHeight(self.buttonBarView.frame);
    frame.size.height -= CGRectGetHeight(self.buttonBarView.frame);
    self.containerView.frame = frame;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UICollectionViewLayoutAttributes *attributes = [_buttonBarView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    CGRect cellRect = attributes.frame;
    [_buttonBarView.selectedBar setFrame:CGRectMake(cellRect.origin.x, _buttonBarView.frame.size.height - 5, cellRect.size.width, 5)];
}

- (void)reloadPagerTabStripView
{
    [super reloadPagerTabStripView];
    if ([self isViewLoaded]) {
        [_buttonBarView reloadData];
        [_buttonBarView moveToIndex:self.currentIndex animated:NO swipeDirection:PTPagerTabStripDirectionNone];
    }
}

- (PTPagerTabStripButtonBarView *)buttonBarView
{
    if (_buttonBarView) {
        return _buttonBarView;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 35, 0, 35)];
    _buttonBarView = [[PTPagerTabStripButtonBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44.0f) collectionViewLayout:flowLayout];
    [_buttonBarView registerClass:[PTPagerTabStripButtonBarViewCell class] forCellWithReuseIdentifier:kButtonBarViewCellIdentifier];
    _buttonBarView.backgroundColor = [UIColor orangeColor];
    _buttonBarView.selectedBar.backgroundColor = [UIColor blackColor];
    _buttonBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return _buttonBarView;
}

- (void)pagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController updateIndicatorFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (self.shouldUpdateButtonBarView) {
        PTPagerTabStripDirection direction = PTPagerTabStripDirectionLeft;
        if (toIndex < fromIndex) {
            direction = PTPagerTabStripDirectionRight;
        }
        [_buttonBarView moveToIndex:toIndex animated:YES swipeDirection:direction];
    }
}

- (void)pagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController updateIndicatorFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withProgressPercentage:(CGFloat)progressPercentage
{
    if (self.shouldUpdateButtonBarView) {
        [_buttonBarView moveFromIndex:fromIndex toIndex:toIndex withProgressPercentage:progressPercentage];
    }
}

#pragma mark - UI

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.font = _buttonBarView.lableFont;
    UIViewController<PTPagerTabStripChildItem> *childController = [self.pagerTabStripChildViewControllers objectAtIndex:indexPath.item];
    [label setText:[childController titleForPagerTabStripViewController:self]];
    CGSize lableSize = [label intrinsicContentSize];
    return CGSizeMake(lableSize.width + (_buttonBarView.leftRightMargin * 2), collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_buttonBarView moveToIndex:indexPath.item animated:YES swipeDirection:PTPagerTabStripDirectionNone];
    self.shouldUpdateButtonBarView = NO;
    [self moveToViewControllerAtIndex:indexPath.item];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pagerTabStripChildViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kButtonBarViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PTPagerTabStripButtonBarViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, _buttonBarView.frame.size.height)];
    }
    PTPagerTabStripButtonBarViewCell *buttonCell = (PTPagerTabStripButtonBarViewCell *)cell;
    UIViewController<PTPagerTabStripChildItem> *childController = [self.pagerTabStripChildViewControllers objectAtIndex:indexPath.item];
    [buttonCell.label setText:[childController titleForPagerTabStripViewController:self]];
    return buttonCell;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [super scrollViewDidEndScrollingAnimation:scrollView];
    if (scrollView == self.containerView) {
        self.shouldUpdateButtonBarView = YES;
    }
}

@end
