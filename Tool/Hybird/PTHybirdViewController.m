//
//  PTHybirdViewController.m
//  PTKit
//
//  Created by LeeHu on 6/24/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTHybirdViewController.h"
#import "Masonry.h"
#import "PTHybirdPlugin.h"

@implementation PTHybirdViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.view addSubview:btn];
	btn.backgroundColor = [UIColor redColor];
	[btn setTitle:@"Start" forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).with.offset(150);
		make.left.equalTo(self.view).with.offset(50);
		make.width.mas_equalTo(100);
		make.height.mas_equalTo(44);
	}];
	
	[btn addTarget:self action:@selector(gotoHyBirdApp) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)gotoHyBirdApp {
	PTHybirdPlugin *plugin = [PTHybirdPlugin sharedInstance];
	[plugin startPage:@"index.html" fromViewController:self];
}

@end
