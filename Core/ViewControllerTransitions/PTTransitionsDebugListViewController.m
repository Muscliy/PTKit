//
//  PTTransitionsDebugListViewController.m
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTTransitionsDebugListViewController.h"
#import "PTInteractiveCollectionViewController.h"
#import "PTPushViewController.h"

@interface PTTransitionsDebugListViewController ()

@property (nonatomic, strong) NITableViewActions *actions;

@end

@implementation PTTransitionsDebugListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _actions = [[NITableViewActions alloc] initWithTarget:self];

    NSArray *tableContents = @[
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"图片交互"] navigationBlock:NIPushControllerAction([PTInteractiveCollectionViewController class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"ViewController切换"] navigationBlock:NIPushControllerAction([PTPushViewController class])],
                               ];
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self setTableData:tableContents];
}

@end
