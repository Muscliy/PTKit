//
//  PTRefreshControlDebugViewController.m
//  PTKit
//
//  Created by LeeHu on 10/23/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTRefreshControlDebugViewController.h"
#import "PTRefreshControl.h"

@interface PTRefreshControlDebugViewController ()<UIScrollViewDelegate,PTRefreshControlDataSource, PTRefreshControlDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PTRefreshControl *headerRefreshControl;
@property (nonatomic, strong) PTRefreshControl *footerRefreshControl;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation PTRefreshControlDebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - 64)];
    _scrollView.backgroundColor = [UIColor orangeColor];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(WIDTH(self.view), 3000);
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    
    _headerRefreshControl = [[PTRefreshControl alloc] initWithFrame:CGRectZero style:PTRefreshControlStyleHeader];
    _headerRefreshControl.backgroundColor= [UIColor blueColor];
    _headerRefreshControl.frame = CGRectMake(0, -100, WIDTH(self.view), 100);
    _headerRefreshControl.delegate = self;
    _headerRefreshControl.dataSource = self;
    [_scrollView addSubview:_headerRefreshControl];
    
    _footerRefreshControl = [[PTRefreshControl alloc] initWithFrame:CGRectZero style:PTRefreshControlStyleFooter];
    _footerRefreshControl.backgroundColor= [UIColor blueColor];
    _footerRefreshControl.frame = CGRectMake(0, _scrollView.contentSize.height, WIDTH(self.view), 100);
    _footerRefreshControl.delegate = self;
    _footerRefreshControl.dataSource = self;
    [_scrollView addSubview:_footerRefreshControl];
    
}

- (void)loading
{
    self.isLoading = YES;
    [self performSelector:@selector(doneLoading) withObject:nil afterDelay:5.0];
}

- (void)doneLoading
{
    self.isLoading = NO;
    [_headerRefreshControl refreshScrollViewDidFinishedLoading:_scrollView];
    [_footerRefreshControl refreshScrollViewDidFinishedLoading:_scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerRefreshControl refreshScrollViewDidScroll:scrollView];
    [_footerRefreshControl refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headerRefreshControl refreshScrollViewDidEndDragging:scrollView];
    [_footerRefreshControl refreshScrollViewDidEndDragging:scrollView];
}

- (BOOL)refreshControlIsLoading:(PTRefreshControl *)control
{
    return self.isLoading;
}

- (void)refreshControlDidTriggerRefresh:(PTRefreshControl *)control
{
    [self loading];
}

@end
