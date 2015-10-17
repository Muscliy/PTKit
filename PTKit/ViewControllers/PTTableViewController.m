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
    _tableView.guidedDelegate = self;
    _tableView.backgroundColor = [self getTableViewBackgroundColor];

    [self.view addSubview:_tableView];

    if ([self hasSearchBar]) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        _searchBar.delegate = self;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        _searchBar.tintColor = [UIColor lightGrayColor];
        self.searchBar.backgroundImage = [UIImage new];
        _tableView.tableHeaderView = self.searchBar;

        _searchDC =
            [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
                                              contentsController:[self getSearchBarController]];
        _searchDC.searchResultsDelegate = self;
        _searchDC.delegate = self;
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

- (UIViewController *)getSearchBarController
{
    return self;
}

- (NICellObject *)getCellObject:(NSIndexPath *)path
{
    return [_model objectAtIndexPath:path];
}

- (void)checkRequestNull
{
    [self onLoadEnd];
    if (!self.tableView.dataSource) {
        [self.tableView showErrorGuideView];
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
    [_tableView checkAndShowEmptyView];
}

- (void)addTableData:(NSArray *)tableCells
{
    if (self.model) {
        [self.model addObjectsFromArray:tableCells];
        [_tableView reloadData];
    } else {
        [self setTableData:tableCells];
    }
    [_tableView checkAndShowEmptyView];
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
    [_tableView checkAndShowEmptyView];
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

#pragma mark -
#pragma mark SearchBarDelegate

- (BOOL)matchTableData:(id)obj keyword:(NSString *)keyword
{
    return FALSE;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)msearchBar textDidChange:(NSString *)searchText
{
    for (id el in msearchBar.subviews) {
        if ([el isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)el;
            [cancelButton setTitle:(searchText.length > 0 ? @"Done" : @"Cancel")
                          forState:UIControlStateNormal];
            break;
        }
    }

    if (!searchText || [searchText isEqualToString:@""]) {
        return;
    }

    NSMutableArray *searchData = [@[] mutableCopy];
    NSUInteger sectionCount = [_tableView numberOfSections];
    NIMutableTableViewModel *m = (NIMutableTableViewModel *)_tableView.dataSource;
    for (NSInteger s = 0; s < sectionCount; s++) {
        NSUInteger count = [_tableView numberOfRowsInSection:s];
        for (NSUInteger i = 0; i < count; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:s];
            id obj = [m objectAtIndexPath:path];
            if ([self matchTableData:obj keyword:searchText])
                [searchData addObject:obj];
        }
    }

    self.searchModel =
        [[NITableViewModel alloc] initWithListArray:searchData delegate:(id)[NICellFactory class]];

    _searchDC.searchResultsDataSource = _searchModel;
    _searchDC.searchResultsDelegate = self;
    _searchDC.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)msearchBar
{
    [msearchBar resignFirstResponder];
    [_searchDC setActive:NO animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)msearchBar
{
    for (id el in msearchBar.subviews) {
        if ([el isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)el;
            [cancelButton setTitle:@"Done" forState:UIControlStateNormal];
        } else if ([el isKindOfClass:[UITextField class]]) {
            UITextField *searchText = (UITextField *)el;
            searchText.returnKeyType = UIReturnKeyDone;
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [_tableView reloadData];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [controller.searchBar setShowsCancelButton:YES animated:NO];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        for (UIView *subView in [[controller.searchBar.subviews firstObject] subviews]) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    } else {
        for (UIView *subView in controller.searchBar.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [(UIButton *)subView setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
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
