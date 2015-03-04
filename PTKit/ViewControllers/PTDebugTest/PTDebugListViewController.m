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

@interface PTDebugListViewController ()<PTQRCodeReaderViewControllerDelegate>

@property (nonatomic, strong) NITableViewActions *actions;

@end

@implementation PTDebugListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor * color = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    PTNavigationBar *navBar = (PTNavigationBar *)self.navigationController.navigationBar;
    [navBar setNavigationBarWithColor:color];
    
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    NIActionBlock codeBlock = ^(id object, id target, NSIndexPath *indexPath) {
       
        PTQRCodeReaderViewController *vc = [[PTQRCodeReaderViewController alloc] init];
        vc.title = @"扫一扫";
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        return YES;
    };

    
    NSArray *tableContents = @[
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"积木"] navigationBlock:NIPushControllerAction([PTModuleCollectionViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"扫一扫"] navigationBlock:codeBlock],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"过场动画"] navigationBlock:NIPushControllerAction([PTTransitionsDebugListViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"系统字体"] navigationBlock:NIPushControllerAction([PTFontListViewController class])]
                               ];
    
    
    
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self setTableData:tableContents];
}

- (void)qrcodeReadResult:(BOOL)isOK readStrResult:(NSString *)result
{
    UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 20)];
    label.text = result;
    [vc.view addSubview:label];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PTQRCodeReaderViewControllerDelegate
- (void)QRCodeReaderView:(UIViewController *)vc relsutCode:(NSString *)code
{
}



@end
