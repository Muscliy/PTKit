//
//  PTCollectionViewController.m
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTCollectionViewController.h"
#import "NIFoundationMethods.h"
#import "NICollectionViewCellFactory.h"
#import "PTCollectionView.h"
#define PADDING 40

@interface PTCollectionViewController () {
}

@end

@implementation PTCollectionViewController

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    _loadingHead.delegate = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.view.bounds;
    _collectionView =
    [[PTCollectionView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)
                       collectionViewLayout:[self flowLayout]];
    _collectionView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical = YES; // Do any additional setup after loading the view.ˆ
    [self.view addSubview:_collectionView];
    
    if ([self hasLoadingHead]) {
        CGRect loadHeadFrame = CGRectMake(0, -CGRectGetHeight(self.collectionView.frame),
                                          CGRectGetWidth(self.collectionView.frame),
                                          CGRectGetHeight(self.collectionView.frame));
        _loadingHead =
        [[EGORefreshTableHeaderView alloc] initWithFrame:loadHeadFrame
                                          arrowImageName:@"uikit_f52"
                                               textColor:RGBCOLOR(147, 147, 147)];
        self.loadingHead.delegate = self;
        [self.collectionView addSubview:self.loadingHead];
        [self.loadingHead refreshLastUpdatedDate];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UICollectionViewLayout *)flowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    return flowLayout;
}

- (void)setCollectionData:(NSArray *)collectionCells
{
    _model =
    [[NIMutableCollectionViewModel alloc] initWithSectionedArray:collectionCells delegate:self];
    _collectionView.dataSource = _model;
    [_collectionView reloadData];
    [_collectionView checkAndShowEmptyView];
}

- (void)addCollectionData:(NSArray *)collectionCells
{
}

- (void)appendCollectionData:(NSArray *)collectionCells
{
}

- (void)addCollectionDataWithSectionedArray:(NSArray *)sectionedArray
{
}

- (BOOL)loadByPage
{
    return NO;
}

- (void)onLoadNextPage
{
}

- (void)onLoadEnd
{
}

- (void)egoRefreshServerData
{
    isEGORefresh = YES;
}

- (BOOL)hasLoadingHead
{
    return NO;
}

//------------------------

#pragma mark - UIScrollDelegate

//------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self hasLoadingHead]) {
        [self.loadingHead egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self hasLoadingHead]) {
        [self.loadingHead egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

//------------------------

#pragma mark - NICollectionViewModelDelegate

//------------------------

- (UICollectionViewCell *)collectionViewModel:(NICollectionViewModel *)collectionViewModel
                        cellForCollectionView:(UICollectionView *)collectionView
                                  atIndexPath:(NSIndexPath *)indexPath
                                   withObject:(id)object
{
    return [NICollectionViewCellFactory collectionViewModel:collectionViewModel
                                      cellForCollectionView:collectionView
                                                atIndexPath:indexPath
                                                 withObject:object];
}

- (UICollectionReusableView *)collectionViewModel:(NICollectionViewModel *)collectionViewModel
                                   collectionView:(UICollectionView *)collectionView
                viewForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *v = [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
    return v;
}

//------------------------

#pragma mark - EGORefreshTableHeaderDelegate

//------------------------

#pragma mark - EGORefreshTableHeaderDelegate
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return self.isLoading;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self egoRefreshServerData];
}

- (void)doneLoadSeverData
{
    if (isEGORefresh) {
        [self.loadingHead egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
        [self.loadingHead refreshLastUpdatedDate];
        isEGORefresh = !isEGORefresh;
    }
}

#pragma mark - XMGuidedViewDelegate
- (UIView *)getEmptyView
{
    return nil;
}

- (UIView *)getLoadingView
{
    return nil;
}

- (UIView *)getErrorView
{
    return nil;
}

- (UIView *)getGuideViewContain:(UIImage *)icon
{
    return nil;
}

- (UIView *)getGuideViewContain:(UIImage *)icon withTitle:(NSString *)title
{
    return nil;
}

- (UIView *)getGuideViewContain:(UIImage *)icon
                      withTitle:(NSString *)title
                withButtonTitle:(NSString *)buttonTitle
                         action:(SEL)action
{
    return nil;
}

@end
