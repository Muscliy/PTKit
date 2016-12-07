//
//  PTPagerTabStripViewController.m
//  PTKit
//
//  Created by LeeHu on 5/6/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTPagerTabStripViewController.h"

@interface PTPagerTabStripViewController ()
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation PTPagerTabStripViewController {
    NSUInteger _lastPageNumber;
    CGFloat _lastContentOffset;
    NSUInteger _pageBeforeRotate;
    NSArray *_originalPagerTabStripChildViewControllers;
    CGSize _lastSize;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self pagerTabStripViewControllerInit];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self pagerTabStripViewControllerInit];
    }
    return self;
}


-(void)pagerTabStripViewControllerInit
{
    _currentIndex = 0;
    _delegate = self;
    _dataSource = self;
    _lastContentOffset = 0.0f;
    _isElasticIndicatorLimit = NO;
    _skipIntermediateViewControllers = YES;
    _isProgressiveIndicator = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.containerView){
        self.containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:self.containerView];
    }
    self.containerView.bounces = YES;
    [self.containerView setAlwaysBounceHorizontal:YES];
    [self.containerView setAlwaysBounceVertical:NO];
    self.containerView.scrollsToTop = NO;
    self.containerView.delegate = self;
    self.containerView.showsVerticalScrollIndicator = NO;
    self.containerView.showsHorizontalScrollIndicator = NO;
    self.containerView.pagingEnabled = YES;
    
    if (self.dataSource){
        _pagerTabStripChildViewControllers = [self.dataSource childViewControllersForPagerTabStripViewController:self];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _lastSize = self.containerView.bounds.size;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateIfNeeded];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateIfNeeded];
    if  ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending){
        // SYSTEM_VERSION_LESS_THAN 8.0
        [self.view layoutSubviews];
    }
}

#pragma mark - move to another view controller

-(void)moveToViewControllerAtIndex:(NSUInteger)index
{
    [self moveToViewControllerAtIndex:index animated:YES];
}


-(void)moveToViewControllerAtIndex:(NSUInteger)index animated:(bool)animated
{
    if (![self isViewLoaded]){
        self.currentIndex = index;
    }
    else{
        if (self.skipIntermediateViewControllers && ABS(self.currentIndex - index) > 1){
            NSArray * originalPagerTabStripChildViewControllers = self.pagerTabStripChildViewControllers;
            NSMutableArray * tempChildViewControllers = [NSMutableArray arrayWithArray:originalPagerTabStripChildViewControllers];
            UIViewController * currentChildVC = [originalPagerTabStripChildViewControllers objectAtIndex:self.currentIndex];
            NSUInteger fromIndex = (self.currentIndex < index) ? index - 1 : index + 1;
            [tempChildViewControllers setObject:[originalPagerTabStripChildViewControllers objectAtIndex:fromIndex] atIndexedSubscript:self.currentIndex];
            [tempChildViewControllers setObject:currentChildVC atIndexedSubscript:fromIndex];
            _pagerTabStripChildViewControllers = tempChildViewControllers;
            [self.containerView setContentOffset:CGPointMake([self pageOffsetForChildIndex:fromIndex], 0) animated:NO];
            if (self.navigationController){
                self.navigationController.view.userInteractionEnabled = NO;
            }
            else{
                self.view.userInteractionEnabled = NO;
            }
            _originalPagerTabStripChildViewControllers = originalPagerTabStripChildViewControllers;
            [self.containerView setContentOffset:CGPointMake([self pageOffsetForChildIndex:index], 0) animated:YES];
        }
        else{
            [self.containerView setContentOffset:CGPointMake([self pageOffsetForChildIndex:index], 0) animated:animated];
        }
        
    }
}


-(void)moveToViewController:(UIViewController *)viewController
{
    [self moveToViewControllerAtIndex:[self.pagerTabStripChildViewControllers indexOfObject:viewController]];
}


#pragma mark - PTPagerTabStripViewControllerDelegate

-(void)pagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex{
    
}

-(void)pagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
{
}


#pragma mark - PTPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController
{
    return self.pagerTabStripChildViewControllers;
}


#pragma mark - Helpers

-(void)updateIfNeeded
{
    if (!CGSizeEqualToSize(_lastSize, self.containerView.bounds.size)){
        [self updateContent];
    }
}

-(PTPagerTabStripDirection)scrollDirection
{
    if (self.containerView.contentOffset.x > _lastContentOffset){
        return PTPagerTabStripDirectionLeft;
    }
    else if (self.containerView.contentOffset.x < _lastContentOffset){
        return PTPagerTabStripDirectionRight;
    }
    return PTPagerTabStripDirectionNone;
}

-(BOOL)canMoveToIndex:(NSUInteger)index
{
    return (self.currentIndex != index && self.pagerTabStripChildViewControllers.count > index);
}

-(CGFloat)pageOffsetForChildIndex:(NSUInteger)index
{
    return (index * CGRectGetWidth(self.containerView.bounds));
}

-(CGFloat)offsetForChildIndex:(NSUInteger)index
{
    return (index * CGRectGetWidth(self.containerView.bounds) + ((CGRectGetWidth(self.containerView.bounds) - CGRectGetWidth(self.view.bounds)) * 0.5));
}

-(CGFloat)offsetForChildViewController:(UIViewController *)viewController
{
    NSInteger index = [self.pagerTabStripChildViewControllers indexOfObject:viewController];
    if (index == NSNotFound){
        @throw [NSException exceptionWithName:NSRangeException reason:nil userInfo:nil];
    }
    return [self offsetForChildIndex:index];
}

-(NSUInteger)pageForContentOffset:(CGFloat)contentOffset
{
    NSInteger result = [self virtualPageForContentOffset:contentOffset];
    return [self pageForVirtualPage:result];
}

-(NSInteger)virtualPageForContentOffset:(CGFloat)contentOffset
{
    NSInteger result = (contentOffset + (1.5f * [self pageWidth])) / [self pageWidth];
    return result - 1;
}

-(NSUInteger)pageForVirtualPage:(NSInteger)virtualPage
{
    if (virtualPage < 0){
        return 0;
    }
    if (virtualPage > self.pagerTabStripChildViewControllers.count - 1){
        return self.pagerTabStripChildViewControllers.count - 1;
    }
    return virtualPage;
}

-(CGFloat)pageWidth
{
    return CGRectGetWidth(self.containerView.bounds);
}

-(CGFloat)scrollPercentage
{
    if ([self scrollDirection] == PTPagerTabStripDirectionLeft || [self scrollDirection] == PTPagerTabStripDirectionNone){
        return fmodf(self.containerView.contentOffset.x, [self pageWidth]) / [self pageWidth];
    }
    return 1 - fmodf(self.containerView.contentOffset.x >= 0 ? self.containerView.contentOffset.x : [self pageWidth] + self.containerView.contentOffset.x, [self pageWidth]) / [self pageWidth];
}

-(void)updateContent
{
    if (!CGSizeEqualToSize(_lastSize, self.containerView.bounds.size)){
        _lastSize = self.containerView.bounds.size;
        [self.containerView setContentOffset:CGPointMake([self pageOffsetForChildIndex:self.currentIndex], 0) animated:NO];
    }
    NSArray * childViewControllers = self.pagerTabStripChildViewControllers;
    self.containerView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.bounds) * childViewControllers.count, self.containerView.contentSize.height);
    
    [childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController * childController = (UIViewController *)obj;
        CGFloat pageOffsetForChild = [self pageOffsetForChildIndex:idx];
        if (fabs(self.containerView.contentOffset.x - pageOffsetForChild) < CGRectGetWidth(self.containerView.bounds)){
            if (![childController parentViewController]){
                [self addChildViewController:childController];
                [childController didMoveToParentViewController:self];
                CGFloat childPosition = [self offsetForChildIndex:idx];
                [childController.view setFrame:CGRectMake(childPosition, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.containerView.bounds))];
                childController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                [self.containerView addSubview:childController.view];
            }
            else{
                CGFloat childPosition = [self offsetForChildIndex:idx];
                [childController.view setFrame:CGRectMake(childPosition, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.containerView.bounds))];
                childController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            }
        }
        else{
            if ([childController parentViewController]){
                [childController.view removeFromSuperview];
                [childController willMoveToParentViewController:nil];
                [childController removeFromParentViewController];
            }
        }
    }];
    
    NSUInteger oldCurrentIndex = self.currentIndex;
    NSInteger virtualPage = [self virtualPageForContentOffset:self.containerView.contentOffset.x];
    NSUInteger newCurrentIndex = [self pageForVirtualPage:virtualPage];
    self.currentIndex = newCurrentIndex;
    
    if (self.isProgressiveIndicator){
        if ([self.delegate respondsToSelector:@selector(pagerTabStripViewController:updateIndicatorFromIndex:toIndex:withProgressPercentage:)]){
            CGFloat scrollPercentage = [self scrollPercentage];
            if (scrollPercentage > 0) {
                NSInteger fromIndex = self.currentIndex;
                NSInteger toIndex = self.currentIndex;
                PTPagerTabStripDirection scrollDirection = [self scrollDirection];
                if (scrollDirection == PTPagerTabStripDirectionLeft){
                    if (virtualPage > self.pagerTabStripChildViewControllers.count - 1){
                        fromIndex = self.pagerTabStripChildViewControllers.count - 1;
                        toIndex = self.pagerTabStripChildViewControllers.count;
                    }
                    else{
                        if (scrollPercentage > 0.5f){
                            fromIndex = MAX(toIndex - 1, 0);
                        }
                        else{
                            toIndex = fromIndex + 1;
                        }
                    }
                }
                else if (scrollDirection == PTPagerTabStripDirectionRight) {
                    if (virtualPage < 0){
                        fromIndex = 0;
                        toIndex = -1;
                    }
                    else{
                        if (scrollPercentage > 0.5f){
                            fromIndex = MIN(toIndex + 1, self.pagerTabStripChildViewControllers.count - 1);
                        }
                        else{
                            toIndex = fromIndex - 1;
                        }
                    }
                }
                [self.delegate pagerTabStripViewController:self updateIndicatorFromIndex:fromIndex toIndex:toIndex withProgressPercentage:(self.isElasticIndicatorLimit ? scrollPercentage : ( toIndex < 0 || toIndex >= self.pagerTabStripChildViewControllers.count ? 0 : scrollPercentage ))];
            }
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(pagerTabStripViewController:updateIndicatorFromIndex:toIndex:)] && oldCurrentIndex != newCurrentIndex){
            [self.delegate pagerTabStripViewController:self
                              updateIndicatorFromIndex:MIN(oldCurrentIndex, self.pagerTabStripChildViewControllers.count - 1)
                                               toIndex:newCurrentIndex];
        }
    }
}


-(void)reloadPagerTabStripView
{
    if ([self isViewLoaded]){
        [self.pagerTabStripChildViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController * childController = (UIViewController *)obj;
            if ([childController parentViewController]){
                [childController.view removeFromSuperview];
                [childController willMoveToParentViewController:nil];
                [childController removeFromParentViewController];
            }
        }];
        _pagerTabStripChildViewControllers = self.dataSource ? [self.dataSource childViewControllersForPagerTabStripViewController:self] : @[];
        self.containerView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.bounds) * _pagerTabStripChildViewControllers.count, self.containerView.contentSize.height);
        if (self.currentIndex >= _pagerTabStripChildViewControllers.count){
            self.currentIndex = _pagerTabStripChildViewControllers.count - 1;
        }
        [self.containerView setContentOffset:CGPointMake([self pageOffsetForChildIndex:self.currentIndex], 0)  animated:NO];
        [self updateContent];
    }
}

#pragma mark - UIScrollViewDelegte

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.containerView == scrollView){
        [self updateContent];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.containerView == scrollView){
        _lastPageNumber = [self pageForContentOffset:scrollView.contentOffset.x];
        _lastContentOffset = scrollView.contentOffset.x;
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.containerView == scrollView && _originalPagerTabStripChildViewControllers){
        _pagerTabStripChildViewControllers = _originalPagerTabStripChildViewControllers;
        _originalPagerTabStripChildViewControllers = nil;
        if (self.navigationController){
            self.navigationController.view.userInteractionEnabled = YES;
        }
        else{
            self.view.userInteractionEnabled = YES;
        }
        [self updateContent];
    }
}



#pragma mark - Orientation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    _pageBeforeRotate = self.currentIndex;
    __typeof__(self) __weak weakSelf = self;
    
    UIInterfaceOrientation fromOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     [weakSelf didRotateFromInterfaceOrientation:fromOrientation];
                                 }];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _pageBeforeRotate = self.currentIndex;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.currentIndex = _pageBeforeRotate;
    [self updateIfNeeded];
}

@end
