//
//  PTUIKitCategoryViewController.m
//  PTKit
//
//  Created by LeeHu on 5/30/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTUIKitCategoryViewController.h"
#import "PTAlertViewDemoViewCotroller.h"
#import "PTDynamicsViewController.h"
#import "PTRefreshControlDebugViewController.h"
#import "PTMultiColorLoader.h"
#import "PTLayerListViewController.h"
#import "PTFloatingHeaderViewController.h"
#import "PTTagListViewController.h"
#import "PTSegmentedControlViewController.h"
#import "PTModuleCollectionViewController.h"
#import "PTWebViewController.h"


@interface PTUIKitCategoryViewController ()

@property (nonatomic, strong) NITableViewActions *actions;

@end

@implementation PTUIKitCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _actions = [[NITableViewActions alloc] initWithTarget:self];
	
	NIActionBlock loader = ^(id object, id target, NSIndexPath *indexPath) {
		
		UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
		PTMultiColorLoader *loader = [[PTMultiColorLoader alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
		loader.colors = @[[UIColor cyanColor],[UIColor purpleColor],[UIColor brownColor],[UIColor orangeColor]];
		vc.view.backgroundColor = [UIColor whiteColor];
		[vc.view addSubview:loader];
		loader.center = CGPointMake(vc.view.bounds.size.width / 2.0, vc.view.bounds.size.height / 2.0);
		[loader startAnimation];
		return YES;
	};
	
    NSArray *tableContents = @[
							   [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"CALayer"] navigationBlock:NIPushControllerAction([PTLayerListViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"UIAlertView"] navigationBlock:NIPushControllerAction([PTAlertViewDemoViewCotroller class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"PTRefreshControl"] navigationBlock:NIPushControllerAction([PTRefreshControlDebugViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"Dynamics"] navigationBlock:NIPushControllerAction([PTDynamicsViewController class])],
							   [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"PTMultiLoader"] navigationBlock:loader],
							   [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"PTFloatHeader"] navigationBlock:NIPushControllerAction([PTFloatingHeaderViewController class])],
							    [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"PTTagList"] navigationBlock:NIPushControllerAction([PTTagListViewController class])],
							   [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"PTSegmentedcontrol"] navigationBlock:NIPushControllerAction([PTSegmentedControlViewController class])],
							   [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"PTModuleCollectionView"] navigationBlock:NIPushControllerAction([PTModuleCollectionViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"PTWebViewController"] navigationBlock:NIPushControllerAction([PTWebViewController class])],
                               ];
    
    
    
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self setTableData:tableContents];

}

@end
