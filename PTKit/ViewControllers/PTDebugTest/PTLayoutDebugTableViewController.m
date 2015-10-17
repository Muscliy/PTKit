//
//  PTLayoutDebugTableViewController.m
//  PTKit
//
//  Created by LeeHu on 8/14/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTLayoutDebugTableViewController.h"
#import "PTLayoutTableViewCell.h"
#import "Masonry.h"

@implementation PTLayoutDebugTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *sv = [UIView new];
    [self.view addSubview:sv];

    sv.backgroundColor = [UIColor blackColor];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    UIView *sv1 = [UIView new];
    [sv addSubview:sv1];
    sv1.backgroundColor = [UIColor redColor];
    [sv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (NICellObject *)createLayoutCell
{
    NICellObject *cellObject = [PTLayoutTableViewCell createObject:self userData:self];
    return cellObject;
}

@end
