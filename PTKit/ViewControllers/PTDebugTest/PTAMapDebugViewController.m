//
//  PTAMapDebugViewController.m
//  PTKit
//
//  Created by LeeHu on 4/29/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTAMapDebugViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchObj.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface PTAMapDebugViewController ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapInputTipsSearchRequest *inputRequest;

@end

@implementation PTAMapDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"85c75ddbe8f30e45238cf15472f0beac" Delegate:self];
    _search.language = AMapSearchLanguage_zh_CN;
    _inputRequest = [[AMapInputTipsSearchRequest alloc] init];
    _inputRequest.keywords = @"西湖区";
    _inputRequest.city = @[@"杭州"];
    _inputRequest.searchType = AMapSearchType_InputTips;
    [_search AMapInputTipsSearch:_inputRequest];
}

#pragma mark - AMapSearchDelegate
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    
}


@end
