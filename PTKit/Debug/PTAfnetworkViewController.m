//
//  PTAfnetworkViewController.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTAfnetworkViewController.h"
#import "ITopicService.h"

@implementation PTAfnetworkViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[[ITopicService create] getWeather:@"json" onSuccess:^(NSArray *ret, RpcContext *context) {
		
	} onFail:^(RpcContext *context) {
		
	}];
}


@end
