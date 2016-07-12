//
//  PTDebugListViewController.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTDebugListViewController.h"
#import "PTModuleCollectionViewController.h"
#import "PTNavigationBar.h"
#import "PTQRCodeReaderViewController.h"
#import "PTTransitionsDebugListViewController.h"
#import "PTFontListViewController.h"
#import "PTImageSizeDebugViewController.h"
#import "PTTagListViewController.h"
#import "PTSegmentedControlViewController.h"
#import "PTFloatingHeaderViewController.h"
#import "extobjc.h"
#import "PTButtonBarPagerTabStripExampleViewController.h"
#import "PTAMapDebugViewController.h"
#import "PTReactiveCocoaDemoViewController.h"
#import "PTUIKitCategoryViewController.h"
#import "PTLayoutDebugTableViewController.h"
#import "PTFoundationDebugListTableViewController.h"
#import "JSONKit.h"
#import "NSObject+Introspection.h"
#import "Person.h"

@interface PTDebugListViewController ()<PTQRCodeReaderViewControllerDelegate>

@property (nonatomic, strong) NITableViewActions *actions;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) PTLayoutDebugTableViewController *searchResultController;

@end

@implementation PTDebugListViewController

- (BOOL)hasSearchBar
{
	return YES;
}

- (UISearchController *)getSearchBarController {
	self.searchResultController = [[PTLayoutDebugTableViewController alloc] initWithNibName:nil bundle:nil];
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
	return self.searchController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//NSLog(@"%@",[NSMutableSet properties]);
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NIActionBlock codeBlock = ^(id object, id target, NSIndexPath *indexPath) {
       
        return YES;
    };

    
    NSArray *tableContents = @[
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"UIKit"] navigationBlock:NIPushControllerAction([PTUIKitCategoryViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"NSFoundation"] navigationBlock:NIPushControllerAction([PTFoundationDebugListTableViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"Layout"] navigationBlock:NIPushControllerAction([PTLayoutDebugTableViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"网易首页类目切换"] navigationBlock:NIPushControllerAction([PTButtonBarPagerTabStripExampleViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"高德搜索"] navigationBlock:NIPushControllerAction([PTAMapDebugViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"积木"] navigationBlock:NIPushControllerAction([PTModuleCollectionViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"扫一扫"] navigationBlock:codeBlock],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"过场动画"] navigationBlock:NIPushControllerAction([PTTransitionsDebugListViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"系统字体"] navigationBlock:NIPushControllerAction([PTFontListViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"图片尺寸"] navigationBlock:NIPushControllerAction([PTImageSizeDebugViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"Tag List"] navigationBlock:NIPushControllerAction([PTTagListViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"segmented control"] navigationBlock:NIPushControllerAction([PTSegmentedControlViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"头部浮动控件"] navigationBlock:NIPushControllerAction([PTFloatingHeaderViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"ReactiveCocoa"] navigationBlock:NIPushControllerAction([PTReactiveCocoaDemoViewController class])]
                               ];
    
    
    
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self setTableData:tableContents];
    
    //[self extobjcTest];
    [self parseJosnString];
	Person *p = [[Person alloc] init];
	p.firstName = @"三";
	p.lastName = @"张";
	NSLog(@"%@",p);
}


- (void)parseJosnString
{

}

- (void)extobjcTest
{
    
}

- (void)qrcodeReadResult:(BOOL)isOK readStrResult:(NSString *)result
{
    UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 20)];
    label.text = result;
    [vc.view addSubview:label];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
 
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

#pragma mark - PTQRCodeReaderViewControllerDelegate
- (void)QRCodeReaderView:(UIViewController *)vc relsutCode:(NSString *)code
{
}

@end
