//
//  NSTimer+Extents.h
//  PTKit
//
//  Created by LeeHu on 14/12/12.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NSTimerCallBack)();
typedef void (^NSTimerInterruptCallBack)(BOOL *stop);

@interface NSTimer (Extents)

+ (NSTimer *)pt_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                       repeats:(BOOL)repeats
                                  blockHandler:(NSTimerCallBack)block;

+ (NSTimer *)pt_scheduledInterruptTimerWithTimeInterval:(NSTimeInterval)seconds
                                           blockHandler:(NSTimerInterruptCallBack)block;

@end
