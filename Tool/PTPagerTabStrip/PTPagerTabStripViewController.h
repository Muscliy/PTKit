//
//  PTPagerTabStripViewController.h
//  PTKit
//
//  Created by LeeHu on 5/6/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTPagerTabStripViewController;


@protocol PTPagerTabStripChildItem <NSObject>

@required

- (NSString *)titleForPagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController;

@optional

- (UIImage *)imageForPagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController;
- (UIColor *)colorForPagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController;

@end


typedef NS_ENUM(NSUInteger, PTPagerTabStripDirection) {
    PTPagerTabStripDirectionLeft,
    PTPagerTabStripDirectionRight,
    PTPagerTabStripDirectionNone
};



@protocol PTPagerTabStripViewControllerDelegate <NSObject>

@optional

-(void)pagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex;

-(void)pagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage;

@end

@protocol PTPagerTabStripViewControllerDataSource <NSObject>

@required

-(NSArray *)childViewControllersForPagerTabStripViewController:(PTPagerTabStripViewController *)pagerTabStripViewController;

@end

@interface PTPagerTabStripViewController : UIViewController<UIScrollViewDelegate, PTPagerTabStripViewControllerDelegate, PTPagerTabStripViewControllerDataSource>

@property (nonatomic, readonly) NSArray * pagerTabStripChildViewControllers;
@property (nonatomic, strong) UIScrollView * containerView;
@property (nonatomic, weak) id<PTPagerTabStripViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<PTPagerTabStripViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSUInteger currentIndex;
@property (nonatomic, assign) BOOL skipIntermediateViewControllers;
@property (nonatomic, assign) BOOL isProgressiveIndicator;
@property (nonatomic, assign) BOOL isElasticIndicatorLimit;
f
/**
 *
 *
 *  @param index 
 */
-(void)moveToViewControllerAtIndex:(NSUInteger)index;
-(void)moveToViewController:(UIViewController *)viewController;
-(void)reloadPagerTabStripView;

@end
