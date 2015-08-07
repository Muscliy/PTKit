//
//  PTLogger.m
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTLogger.h"
#import "PTDDFormatter.h"
#import "CocoaLumberjack.h"

static DDFileLogger *fileLogger;
#ifdef DEBUG
static DDLogLevel ddLogLevel = LOG_LEVEL_DEBUG;
#else
static DDLogLevel ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation PTLogger

+ (void)load
{
    PTDDFormatter *formatter = [[PTDDFormatter alloc] init];
#if defined(DEBUG) || TARGET_IPHONE_SIMULATOR
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif

    fileLogger = [[DDFileLogger alloc] init];
    [fileLogger setLogFormatter:formatter];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

+ (DDLogLevel)ddLogLevel
{
    return ddLogLevel;
}

+ (void)ddSetLogLevel:(DDLogLevel)level
{
    ddLogLevel = level;
}

@end