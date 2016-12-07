//
//  PTSearchDisplayController.m
//  PTKit
//
//  Created by LeeHu on 9/21/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTSearchDisplayController.h"
#import "PTSearchNavigatonBar.h"
#import "PTPopViewController.h"

@interface PTSearchDisplayController () <PTSearchNavigationBarDelegate>

@property (nonatomic, strong) PTSearchNavigatonBar *searchBar;
@property (nonatomic, strong) UIViewController *currentChildController;

@end

@implementation PTSearchDisplayController

- (void)dealloc
{
    _searchBar.delegate = nil;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubViews];

    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 60, 40);
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnOnClick
{
    PTPopViewController *vc = [[PTPopViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addSearchBar];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenSearchBar];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeSearchBar];
}

- (void)viewAppearAnimateAlongsideTransition:
        (id<UIViewControllerTransitionCoordinatorContext>)context
{
    _searchBar.alpha = 1;
}

- (void)viewAppearAnimateAlongsideCompletion:
        (id<UIViewControllerTransitionCoordinatorContext>)context
{
    if ([context isCancelled]) {
        [self removeSearchBar];
    }
}

- (void)initSubViews
{
    _currentChildController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    _currentChildController.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:_currentChildController];

    if (!_searchSuggestionController) {
        _searchSuggestionController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        _searchSuggestionController.view.backgroundColor = [UIColor lightGrayColor];
    }
    [self addChildViewController:_searchSuggestionController];

    if (!_searchContentsController) {
        _searchContentsController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        _searchContentsController.view.backgroundColor = [UIColor lightGrayColor];
    }
    [self addChildViewController:_searchContentsController];

    [self.view addSubview:_currentChildController.view];
}

#pragma mark - search Bar
- (void)addSearchBar
{
    _searchBar = [[PTSearchNavigatonBar alloc]
        initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopBarHeight)];
    _searchBar.backgroundColor = COLOR_TITLEBAR_GREEN;
    _searchBar.alpha = 0;
    _searchBar.delegate = self;
    if (self.appearsFirstTime) {
        [_searchBar becomeFirstResponder];
    }
    [self.navigationController.navigationBar addSubview:_searchBar];
}

- (void)hiddenSearchBar
{
    [UIView animateWithDuration:0.25
                     animations:^{
                       _searchBar.alpha = 0.0;
                     }];
}

- (void)removeSearchBar
{
    [_searchBar removeFromSuperview];
}

- (void)showSuggestionController:(NSString *)text
{
    [self showChildController:_searchSuggestionController];
}

- (void)showContentsController:(NSString *)text
{
    [self showChildController:_searchContentsController];
}

- (void)showChildController:(UIViewController *)controller
{
    if (_currentChildController == controller) {
        return;
    }
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    [self transitionFromViewController:_currentChildController
        toViewController:controller
        duration:0.25
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{

        }
        completion:^(BOOL finished) {
          if (finished) {
              _currentChildController = controller;
          }
        }];
}

- (void)searchText:(NSString *)text
{
    [self showContentsController:text];
}

- (void)searchtextChanged:(NSString *)text
{
    [self showSuggestionController:text];
}

#pragma mark - PTSearchNavigationBarDelegate
- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar beginSearch:(NSString *)text
{
    [self showSuggestionController:text];
}

- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar searchCanceled:(BOOL)canceled
{
    [self leftBarButtonItemOnClick];
}

- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar searchText:(NSString *)text
{
    [self searchText:text];
}

- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar textChanged:(NSString *)text
{
    [self searchtextChanged:text];
}

@end
