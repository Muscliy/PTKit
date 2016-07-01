//
//  PTTableViewDelegate.h
//  PTKit
//
//  Created by LeeHu on 6/30/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTTableView;
@class PTTableViewCellObject;
@class PTTableViewCell;

@protocol PTTableViewDelegate <NSObject>

#pragma mark - TableView Delegate
- (void)tableView:(PTTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withCellObject:(PTTableViewCellObject *)cellObject;
- (void)tableView:(PTTableView *)tableView willDisplayCell:(PTTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withCellObject:(PTTableViewCellObject *)cellObejct;
- (void)tableView:(PTTableView *)tableView setItemforCell:(PTTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withCellObject:(PTTableViewCellObject *)cellObject;
- (void)tableView:(PTTableView *)tableView setCreatedItemforCell:(PTTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withCellObject:(PTTableViewCellObject *)cellObject;

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end
