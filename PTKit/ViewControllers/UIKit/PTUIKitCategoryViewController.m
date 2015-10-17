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

@interface PTUIKitCategoryViewController ()

@property (nonatomic, strong) NITableViewActions *actions;

@end

@implementation PTUIKitCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    
    NSArray *tableContents = @[
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"UIAlertView"] navigationBlock:NIPushControllerAction([PTAlertViewDemoViewCotroller class])],
                               [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"Dynamics"] navigationBlock:NIPushControllerAction([PTDynamicsViewController class])],
                               ];
    
    
    
    self.tableView.delegate = [self.actions forwardingTo:self];
    [self setTableData:tableContents];

}

@end
