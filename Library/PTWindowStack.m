//
//  PTWindowStack.m
//  PTKit
//
//  Created by LeeHu on 12/17/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTWindowStack.h"

@interface PTWindowStack ()

@property (nonatomic, strong) NSMutableArray<UIWindow *> *windows;

@end

@implementation PTWindowStack

PTSingletonImplementation;

- (instancetype)init
{
    if ((self = [super init])) {
        self.windows = [@[] mutableCopy];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window) {
            [self.windows addObject:window];
        }
    }
    return self;
}

+ (UIWindow *)createWindowWithRootVC:(UIViewController *)rootVC
{
    UIWindow *aWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    aWindow.rootViewController = rootVC;
    return aWindow;
}

+ (void)pushWindowWithRootVC:(UIViewController *)rootVC
{
    UIWindow *aWindow = [self createWindowWithRootVC:rootVC];
    [self pushWindow:aWindow];
}

+ (void)pushWindow:(UIWindow *)aWindow
{
    NSMutableArray *arr = [PTWindowStack sharedInstance].windows;
    if ([arr containsObject:aWindow]) {
        return;
    }

    [arr addObject:aWindow];

    aWindow.windowLevel = arr.count;
    [aWindow makeKeyAndVisible];
}

+ (void)popWindow
{
    NSMutableArray *arr = [PTWindowStack sharedInstance].windows;
    if (arr.count <= 1) {
        return;
    }

    [arr removeLastObject];

    UIWindow *aWindow = [arr lastObject];
    [aWindow makeKeyAndVisible];
}

+ (void)popToRootWindow
{
    NSMutableArray *arr = [PTWindowStack sharedInstance].windows;

    while (arr.count > 1) {
        [arr removeLastObject];
    }

    UIWindow *aWindow = [arr lastObject];
    [aWindow makeKeyAndVisible];
}

+ (UIWindow *)topWindow
{
    NSMutableArray *arr = [PTWindowStack sharedInstance].windows;
    assert([arr count] >= 1);
    return [arr lastObject];
}

+ (NSInteger)count
{
    return [PTWindowStack sharedInstance].windows.count;
}

@end
