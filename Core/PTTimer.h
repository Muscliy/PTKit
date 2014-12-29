//
//  PTTimer.h
//  PTKit
//
//  Created by LeeHu on 14/12/12.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSTimer+Extents.h"

@interface PTTimer : NSObject

@property (nonatomic, strong, readonly) NSTimer *timer;
@property (readonly, getter=isValid) BOOL valid;

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                       repeats:(BOOL)repeats
                                  blockHandler:(NSTimerCallBack)block;

+ (instancetype)scheduledInterruptableTimerWithTimeInterval:(NSTimeInterval)seconds
                                               blockHandler:(NSTimerInterruptCallBack)block;

- (void)invalidate;

- (void)fire;


@end
