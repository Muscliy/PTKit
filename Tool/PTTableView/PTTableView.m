//
//  PTTableView.m
//  PTKit
//
//  Created by LeeHu on 14/12/16.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTTableView.h"
#import "NimbusModels.h"
#import "PTTableViewCellObject.h"
#import "PTTableViewDelegate.h"

@interface PTTableView ()<UITableViewDelegate>

@property (nonatomic, assign) CGPoint defaultContentOffset;

@end

@implementation PTTableView

#pragma mark - life cycle
- (void)dealloc {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ((self = [super initWithFrame:frame style:style])) {
		
		self.defaultScrollViewInsets = UIEdgeInsetsMake(0, 0, 0, 0);
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (instancetype)init {
	return [self initWithFrame:CGRectZero style:UITableViewStylePlain];
}


#pragma mark -
#pragma mark Accessors

- (CGPoint)defaultContentOffset {
	return CGPointMake(0, -self.defaultScrollViewInsets.top);
}

- (void)setDefaultScrollViewInsets:(UIEdgeInsets)defaultScrollViewInsets {
	_defaultScrollViewInsets = defaultScrollViewInsets;
	self.contentInset = defaultScrollViewInsets;
	self.contentOffset = self.defaultContentOffset;
}

#pragma mark -
#pragma mark Data source
- (PTTableViewCellObject *)cellObjectAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.model objectAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark TableView Behaviours

- (void)delayReloadData {
	[self performSelector:@selector(reloadData) withObject:nil afterDelay:0.2f];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	PTTableViewCellObject *cellObject = [self cellObjectAtIndexPath:indexPath];

	if ([self.ptDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:withCellObject:)]) {
		[self.ptDelegate tableView:self didSelectRowAtIndexPath:indexPath withCellObject:cellObject];
	}
}



@end
