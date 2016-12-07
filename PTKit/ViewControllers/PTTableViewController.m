//
//  PTTableViewController.m
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTTableViewController.h"
#import "PTUIMathUtilities.h"

@implementation PTTableViewController
@synthesize tableView = _tableView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    self.loadingHead.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect bounds = self.view.frame;
    CGFloat width = bounds.size.width;
    self.tableView = [[PTTableView alloc]
        initWithFrame:CGRectMake(0, 0, width,
                                 bounds.size.height - (kPTStatusBarHeight + kTopBarHeight))
                style:[self getTableStyle]];
    _tableView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = [self getSeparatorStyle];
    _tableView.separatorColor = [self getSeparatorColor];
    _tableView.delegate = self;
    _tableView.ptDelegate = self;
    _tableView.backgroundColor = [self getTableViewBackgroundColor];

    [self.view addSubview:_tableView];

    if ([self hasSearchBar]) {
		UISearchController *searchController = [self getSearchBarController];
		[searchController.searchBar sizeToFit];
		self.tableView.tableHeaderView = searchController.searchBar;
		self.definesPresentationContext = YES;
	}

    if ([self hasLoadingHead]) {
        CGRect loadHeadFrame = CGRectMake(0, -self.tableView.frame.size.height, width,
                                          self.tableView.frame.size.height);
        self.loadingHead =
            [[EGORefreshTableHeaderView alloc] initWithFrame:loadHeadFrame
                                              arrowImageName:@"uikit_f52"
                                                   textColor:[UIColor lightGrayColor]];
        self.loadingHead.delegate = self;
        [self.tableView addSubview:self.loadingHead];
        [self.loadingHead refreshLastUpdatedDate];
    }

    if ([self loadByPage]) {
        // TODO:
    }
	//[self addNavigationBar];
}

- (UITableViewStyle)getTableStyle
{
    return UITableViewStylePlain;
}

- (UITableViewCellSeparatorStyle)getSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UIColor *)getSeparatorColor
{
    return [UIColor lightGrayColor];
}

- (UIColor *)getTableViewBackgroundColor
{
    return [UIColor lightGrayColor];
}

- (BOOL)hasSearchBar
{
    return NO;
}

- (BOOL)loadByPage
{
    return NO;
}

- (BOOL)hasLoadingHead
{
    return NO;
}

- (BOOL)showIndex
{
    return NO;
}

- (id)getTableClass
{
    return [PTTableView class];
}

- (BOOL)canScrollEndEdit
{
    return NO;
}

- (UISearchController *)getSearchBarController
{
	return nil;
}

- (NICellObject *)getCellObject:(NSIndexPath *)path
{
    return [_model objectAtIndexPath:path];
}

- (void)checkRequestNull
{
    [self onLoadEnd];
    if (!self.tableView.dataSource) {
    }
}

- (void)setTableData:(NSArray *)tableCells
{
    NIDASSERT([NSThread isMainThread]);

    self.model = [[NIMutableTableViewModel alloc] initWithSectionedArray:tableCells delegate:self];

    if ([self showIndex]) {
        [_model setSectionIndexType:NITableViewModelSectionIndexDynamic
                        showsSearch:YES
                       showsSummary:NO];
    }

    if (!_model) {
        return;
    }

    _tableView.dataSource = _model;
    [_tableView reloadData];
}

- (void)addTableData:(NSArray *)tableCells
{
    if (self.model) {
        [self.model addObjectsFromArray:tableCells];
        [_tableView reloadData];
    } else {
        [self setTableData:tableCells];
    }
}

- (void)appendTableData:(NSArray *)tableCells
{
    if (self.model) {
        [self addTableData:tableCells];
    } else {
        [self setTableData:tableCells];
    }
}

- (void)addTableDataWithSectionedArray:(NSArray *)sectionedArray
{
    NSIndexSet *indexset = nil;
    if (self.model) {
        [_tableView beginUpdates];
        for (id object in sectionedArray) {
            if ([object isKindOfClass:[NSString class]]) {
                indexset = [self.model addSectionWithTitle:object];
                if (indexset) {
                    [self.tableView insertSections:indexset
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            } else {
                [self.model addObject:object];
            }
        }
        [_tableView endUpdates];
    } else {
        [self setTableData:sectionedArray];
    }
}

#pragma mark -
#pragma mark TableView
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NICellFactory tableView:aTableView
            heightForRowAtIndexPath:indexPath
                              model:aTableView.dataSource];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - NIMutableTableViewModelDelegate

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel
                   cellForTableView:(UITableView *)tableView
                        atIndexPath:(NSIndexPath *)indexPath
                         withObject:(id)object
{
    return [NICellFactory tableViewModel:tableViewModel
                        cellForTableView:tableView
                             atIndexPath:indexPath
                              withObject:object];
}

#pragma mark - scrollView delegate
- (void)onLoadNextPage
{
}

- (void)onLoadEnd
{
    _tableView.tableFooterView.hidden = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_tableView == scrollView && [self loadByPage] &&
        scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) >=
            scrollView.contentSize.height - 5 &&
        self.hasMoreData) {
        _tableView.tableFooterView.hidden = NO;
        [self onLoadNextPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self canScrollEndEdit]) {
        [self.view endEditing:YES];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return NO;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

#pragma mark - CCGuidedViewDelegate
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
    UIView *guideView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *guideIconView = [[UIImageView alloc] initWithImage:icon];
    guideIconView.center =
        CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds) / 2);
    [guideView addSubview:guideIconView];
    return guideView;
}

- (UIView *)getGuideViewContain:(UIImage *)icon withTitle:(NSString *)title
{
    UIView *guideView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *guideIconView = [[UIImageView alloc] initWithImage:icon];
    guideIconView.center =
        CGPointMake(CGRectGetWidth(self.view.bounds) / 4, CGRectGetHeight(self.view.bounds) / 2);
    UILabel *tipLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 20)];
    tipLabel.center =
        CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds) / 2);
    tipLabel.text = title;
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor blackColor];
    [guideView addSubview:guideIconView];
    [guideView addSubview:tipLabel];
    return guideView;
}

- (UIView *)getGuideViewContain:(UIImage *)icon
                      withTitle:(NSString *)title
                withButtonTitle:(NSString *)buttonTitle
                         action:(SEL)action
{
    UIView *guideView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height)];
    guideView.userInteractionEnabled = YES;
    UIImageView *guideIconView = [[UIImageView alloc] initWithImage:icon];
    guideIconView.frame =
        CGRectMake(PTRoundPixelValue((CGRectGetWidth(self.view.bounds) - icon.size.width) / 2.0), 0,
                   icon.size.width, icon.size.height);

    UILabel *tipLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 20)];
    tipLabel.text = title;
    tipLabel.font = [UIFont systemFontOfSize:12.0];
    tipLabel.textColor = [UIColor blackColor];
    [tipLabel sizeToFit];
    tipLabel.frame = CGRectMake(
        PTRoundPixelValue((CGRectGetWidth(self.view.bounds) - CGRectGetWidth(tipLabel.frame)) / 2),
        CGRectGetMaxY(guideIconView.frame) + 15, CGRectGetWidth(tipLabel.frame),
        CGRectGetHeight(tipLabel.frame));

    return guideView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"null"];
}


@end
