//
//  PTTableViewController.h
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTBaseViewCotroller.h"
#import "EGORefreshTableHeaderView.h"
#import "NimbusModels.h"
#import "PTTableView.h"

@interface PTTableViewController : PTBaseViewCotroller<UITableViewDelegate, UISearchBarDelegate,
UISearchDisplayDelegate, EGORefreshTableHeaderDelegate,PTTableViewDelegate,NITableViewModelDelegate>

@property (nonatomic, strong) PTTableView *tableView;
@property (nonatomic, strong) NIMutableTableViewModel *model;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, strong) UISearchDisplayController *searchDC;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NITableViewModel *searchModel;
@property (nonatomic, strong) EGORefreshTableHeaderView *loadingHead;

- (UITableViewStyle)getTableStyle;
- (UITableViewCellSeparatorStyle)getSeparatorStyle;
- (UIColor *)getSeparatorColor;
- (UIViewController *)getSearchBarController;
- (UIColor *)getTableViewBackgroundColor;

- (void)setTableData:(NSArray *)tableCells;
- (void)addTableData:(NSArray *)tableCells;
- (void)appendTableData:(NSArray *)tableCells;
- (NICellObject *)getCellObject:(NSIndexPath *)path;

- (void)addTableDataWithSectionedArray:(NSArray *)sectionedArray;
- (BOOL)hasSearchBar;
- (BOOL)matchTableData:(id)obj keyword:(NSString *)keyword;
- (BOOL)canScrollEndEdit;

- (BOOL)loadByPage;
- (void)onLoadNextPage;
- (void)onLoadEnd;
- (BOOL)hasLoadingHead;
- (BOOL)showIndex;
- (void)checkRequestNull;

- (UIView *)getEmptyView;
- (UIView *)getLoadingView;
- (UIView *)getErrorView;
- (UIView *)getGuideViewContain:(UIImage *)icon;
- (UIView *)getGuideViewContain:(UIImage *)icon withTitle:(NSString *)title;
- (UIView *)getGuideViewContain:(UIImage *)icon
                      withTitle:(NSString *)title
                withButtonTitle:(NSString *)buttonTitle
                         action:(SEL)action;

@end
