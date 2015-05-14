//
//  PTAMapDebugViewController.m
//  PTKit
//
//  Created by LeeHu on 4/29/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTAMapDebugViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "UIBarButtonItem+Extents.h"
#import "UIViewController+POPHUD.h"

@interface PTAMapDebugViewController ()<BMKPoiSearchDelegate>

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) BMKPoiSearch *poisearch;
@property (nonatomic, assign) NSUInteger searchCount;
@property (nonatomic, strong) NSArray *poiList;

@end

@implementation PTAMapDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _poisearch = [[BMKPoiSearch alloc] init];
    _poisearch.delegate = self;
    
    self.searchDC = nil;
    self.cityName = @"杭州";
    self.title = @"杭州";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightAttriTitleItemTarget:self action:@selector(clearRecord) text:@"清空" withSpace:1 color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14.0f] fontSize:14.0f];

    [self showCityList];
}

- (void)clearRecord
{
    self.model = nil;
    [self showCityList];
}

- (void)showCityList
{
    NSArray *tableContents = @[[NITitleCellObject objectWithTitle:@"杭州"],[NITitleCellObject objectWithTitle:@"上海"]];
    [self setTableData:tableContents];
}

- (BOOL)hasSearchBar
{
    return YES;
}

- (void)searchPoi
{
    [self setTableData:nil];
    [self.view endEditing:YES];
    self.searchCount = 0;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc] init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city = self.cityName;
    citySearchOption.keyword = self.searchBar.text;
    if (![_poisearch poiSearchInCity:citySearchOption]) {
        
    }
}

- (void)searchDetailPoi:(BMKPoiInfo *)info
{
    BMKPoiDetailSearchOption *option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = info.uid;
    if (![_poisearch poiDetailSearch:option]) {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NITitleCellObject *cellObject = [self.model objectAtIndexPath:indexPath];
    self.cityName = cellObject.title;
    self.title = self.cityName;
    self.searchBar.placeholder = [NSString stringWithFormat:@"在%@下搜索",self.cityName];
    [self.searchBar becomeFirstResponder];
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher
                result:(BMKPoiResult *)result
             errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    if (error == BMK_SEARCH_NO_ERROR) {
        self.poiList = result.poiInfoList;
        if ([self.poiList count] > 0) {
            [self searchDetailPoi:[self.poiList firstObject]];
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
    } else {
    }
}

- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    self.searchCount ++;
    NSLog(@"%@",poiDetailResult.description);
    NITitleCellObject *cellObject = [NITitleCellObject objectWithTitle:[NSString stringWithFormat:@"%@(%@) %zd",poiDetailResult.name, poiDetailResult.type, self.searchCount]];
    [self appendTableData:@[cellObject]];
    if (self.searchCount == [self.poiList count] - 1) {
        return;
    }
    [self searchDetailPoi:self.poiList[self.searchCount]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchPoi];
}

@end
