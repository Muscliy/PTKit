//
//  PTWindowStack.h
//  PTKit
//
//  Created by LeeHu on 12/17/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTWindowStack : NSObject

PTSingletonInterface;

/**
 *  create controller in new window
 *
 *  @param rootVC
 *
 *  @return
 */
+ (UIWindow *)createWindowWithRootVC:(UIViewController *)rootVC;

/**
 *  add window to stack which window has controller
 *
 *  @param rootVC
 */
+ (void)pushWindowWithRootVC:(UIViewController *)rootVC;

/**
 *  add window to stack
 *
 *  @param window
 */
+ (void)pushWindow:(UIWindow *)window;

/**
 *  remove the visible window unless the top is visible
 */
+ (void)popWindow;

/**
 *  remove window unless root controller's window always key window
 */
+ (void)popToRootWindow;

/**
 *  top window ,the visible window
 *
 *  @return
 */
+ (UIWindow *)topWindow;

/**
 *  app root window which root view controller is home controller
 *
 *  @return
 */
+ (UIWindow *)rootWindow;

/**
 *  number of windows in stack
 *
 *  @return
 */
+ (NSInteger)count;


@end
