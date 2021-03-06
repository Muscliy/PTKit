
//
//  PTFloatingHeaderViewController.m
//  PTKit
//
//  Created by LeeHu on 4/23/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTFloatingHeaderViewController.h"
#import "PTFloatingHeaderView.h"
#import "UINavigationBar+Extents.h"
#import "PTRectMacro.h"

@interface PTFloatingHeaderViewController ()

@property (nonatomic, strong) PTFloatingHeaderView *floatingView;

@end

@implementation PTFloatingHeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    _floatingView = [[PTFloatingHeaderView alloc]
                     initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 88)];
    _floatingView.floatingHeight = 44;
    _floatingView.backgroundColor = [UIColor yellowColor];
    [_floatingView updateScrollViewInsets:self.tableView];
    [self.view addSubview:_floatingView];
    
    NSArray *tableContents = @[[NITitleCellObject objectWithTitle:@"1"],
                               [NITitleCellObject objectWithTitle:@"2"],
                               [NITitleCellObject objectWithTitle:@"3"],
                               [NITitleCellObject objectWithTitle:@"4"],
                               [NITitleCellObject objectWithTitle:@"5"],
                               [NITitleCellObject objectWithTitle:@"6"],
                               [NITitleCellObject objectWithTitle:@"7"],
                               [NITitleCellObject objectWithTitle:@"8"],
                               [NITitleCellObject objectWithTitle:@"9"],
                               [NITitleCellObject objectWithTitle:@"10"],
                               [NITitleCellObject objectWithTitle:@"11"],
                               [NITitleCellObject objectWithTitle:@"12"],
                               [NITitleCellObject objectWithTitle:@"13"],
                               [NITitleCellObject objectWithTitle:@"14"],
                               [NITitleCellObject objectWithTitle:@"15"],
                               [NITitleCellObject objectWithTitle:@"16"],
                               [NITitleCellObject objectWithTitle:@"17"]];
    [self setTableData:tableContents];
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
//    [self.navigationController.navigationBar pt_setTranslationY:(-44 * progress)];
//    [self.navigationController.navigationBar pt_setContentAlpha:1 - progress];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.floatingView scrollViewDidScroll:scrollView];
    
    CGFloat offsetHeight = (CGRectGetHeight(self.floatingView.frame) + kTopBarHeight + kPTStatusBarHeight);
    if (scrollView.contentOffset.y > -offsetHeight) {
        if (scrollView.contentOffset.y >=
            (44 - offsetHeight)) {
            [self setNavigationBarTransformProgress:1];
        } else {
            [self setNavigationBarTransformProgress:((offsetHeight +
                                                      scrollView.contentOffset.y) /
                                                     44)];
        }
    } else {
        [self setNavigationBarTransformProgress:0];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.floatingView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.floatingView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.floatingView scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.floatingView scrollViewDidEndDecelerating:scrollView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CGRect rect = self.floatingView.frame;
    rect.size.height += 20;
    self.floatingView.frame = rect;
    [self.floatingView updateScrollViewInsets:self.tableView];
}

@end
