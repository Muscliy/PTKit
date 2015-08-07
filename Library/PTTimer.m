//
//  PTTimer.m
//  PTKit
//
//  Created by LeeHu on 14/12/12.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTTimer.h"

@interface PTTimer ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PTTimer

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                       repeats:(BOOL)repeats
                                  blockHandler:(NSTimerCallBack)block
{
    PTTimer *timer = [[self alloc] init];
    timer.timer =
        [NSTimer pt_scheduledTimerWithTimeInterval:seconds repeats:repeats blockHandler:block];
    return timer;
}

+ (instancetype)scheduledInterruptableTimerWithTimeInterval:(NSTimeInterval)seconds
                                               blockHandler:(NSTimerInterruptCallBack)block
{
    PTTimer *timer = [[self alloc] init];
    timer.timer = [NSTimer pt_scheduledInterruptTimerWithTimeInterval:seconds blockHandler:block];
    return timer;
}

- (void)dealloc
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)invalidate
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)fire
{
    [_timer fire];
}

- (BOOL)isValid
{
    return [_timer isValid];
}

@end
