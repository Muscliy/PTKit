//
//  PTLayerListViewController.m
//  PTKit
//
//  Created by LeeHu on 1/14/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTLayerListViewController.h"

@interface PTLayerListViewController ()

@end

@implementation PTLayerListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	NSArray *tableContents = @[[NITitleCellObject objectWithTitle:@"CATextLayer"],
							   [NITitleCellObject objectWithTitle:@"CATileLayer"],
							   [NITitleCellObject objectWithTitle:@"CAShapeLayer"],
							   [NITitleCellObject objectWithTitle:@"CAScrollLayer"],
							   [NITitleCellObject objectWithTitle:@"CAReplicatorLayer"],
							   [NITitleCellObject objectWithTitle:@"CAMetalLayer"],
							   [NITitleCellObject objectWithTitle:@"CAGradientLayer"],
							   [NITitleCellObject objectWithTitle:@"CAEmitterLayer"],
							   [NITitleCellObject objectWithTitle:@"CAEAGLLayer"],
							   ];
	
	
	
	[self setTableData:tableContents];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)createCATextLayerDemo
{
	
}

- (void)createCATiledLayerDemo
{
	
}

- (void)createCAShapeLayerDemo
{
	
}

- (void)createCAScrollLayerDemo
{
	
}

- (void)createCAReplicatorLayerDemo
{
	
}

- (void)createCAMetalLayerDemo
{
	
}

- (void)createCAGradientLayerDemo
{
	
}

- (void)createCAEmitterLayerDemo
{
	
}

- (void)createCAEAGLLayerDemo
{
	
}

@end
