//
//  PTHybirdPlugin.m
//  PTKit
//
//  Created by LeeHu on 6/24/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTHybirdPlugin.h"
#import "CDVViewController.h"

@interface PTHybirdPlugin ()

@property(nonatomic,weak) UIViewController* fromViewController;
@property(nonatomic,strong) CDVViewController* cordovaViewController;

@end

@implementation PTHybirdPlugin

PTSingletonImplementation;

- (void)startPage:(NSString*)pageName fromViewController:(UIViewController*)fromViewController
{
	if(!self.cordovaViewController){
		self.cordovaViewController = [CDVViewController new];
	}
	self.fromViewController = fromViewController;
	self.cordovaViewController.startPage = pageName;

	//Optional 添加一个返回按钮
	UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, 50, 40)];//构造一个返回按钮
	
	[btn setImage:[UIImage imageNamed:@"ic_arrow_back_white_48dp.png"] forState:UIControlStateNormal];//设置按钮的背景图片
	
	[btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];//为按钮添加响应事件
	
	[self.cordovaViewController.view addSubview:btn];
	
	[fromViewController presentViewController:self.cordovaViewController animated:YES completion:^{
	}];
}

@end
