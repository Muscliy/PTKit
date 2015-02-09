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

@interface PTDebugListViewController ()

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
    NSArray *tableContents = @[
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"积木"] navigationBlock:NIPushControllerAction([PTModuleCollectionViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"扫一扫"] navigationBlock:NIPushControllerAction([PTQRCodeReaderViewController class])]
                               ];
    
    
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self setTableData:tableContents];
}


@end
