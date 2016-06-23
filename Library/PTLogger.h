//
//  PTLogger.h
//  xmLife
//
//  Created by leehu on 14-9-24.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"


//==============================================================================
#define PTLOG_MACRO(async, lvl, flg, ctx, fmt, ...)         \
LOG_OBJC_MAYBE(async, lvl, flg, ctx, fmt, ##__VA_ARGS__);

#define	PT_LOG_LEVEL			[PTLogger ddLogLevel]

#if defined(DEBUG) && TARGET_IPHONE_SIMULATOR

#define PTLOG_ASYNC_ERROR	NO
#define PTLOG_ASYNC_WARN	NO
#define PTLOG_ASYNC_INFO	NO
#define PTLOG_ASYNC_DEBUG	NO
#define PTLOG_ASYNC_VERBOSE	NO

#else

#define PTLOG_ASYNC_ERROR	LOG_ASYNC_ERROR
#define PTLOG_ASYNC_WARN	LOG_ASYNC_WARN
#define PTLOG_ASYNC_INFO	LOG_ASYNC_INFO
#define PTLOG_ASYNC_DEBUG	LOG_ASYNC_DEBUG
#define PTLOG_ASYNC_VERBOSE	LOG_ASYNC_VERBOSE

#endif

//==============================================================================

/***************************************************************
 ---------慎用Info级别，这个会在发布时也打印日志---------
 ---------慎用Info级别，这个会在发布时也打印日志---------
 *  说明:最终发布出去
 *	PTLogError,PTLogWarn,PTLogInfo三个等级会上报服务器。
 ****************************************************************/

//发布版本上报,等级最高
#define PTLogError(fmt, ...)	PTLOG_MACRO(PTLOG_ASYNC_ERROR, PT_LOG_LEVEL, LOG_FLAG_ERROR, 0, fmt, ##__VA_ARGS__)
//发布版本上报
#define PTLogWarn(fmt, ...)		PTLOG_MACRO(PTLOG_ASYNC_WARN, PT_LOG_LEVEL, LOG_FLAG_WARN, 0, fmt, ##__VA_ARGS__)
//发布版本上报
#define PTLogInfo(fmt, ...)		PTLOG_MACRO(PTLOG_ASYNC_INFO, PT_LOG_LEVEL, LOG_FLAG_INFO, 0, fmt, ##__VA_ARGS__)
//发布版本不会上报
#define PTLogDebug(fmt, ...)	PTLOG_MACRO(PTLOG_ASYNC_DEBUG, PT_LOG_LEVEL, LOG_FLAG_DEBUG, 0, fmt, ##__VA_ARGS__)
//发布版本不会上报
#define PTLogVerbose(fmt, ...)	PTLOG_MACRO(PTLOG_ASYNC_VERBOSE, PT_LOG_LEVEL, LOG_FLAG_VERBOSE, 0, fmt, ##__VA_ARGS__)

//==============================================================================
//只能在调试时使用--发布时啥也不会打印
#ifdef	DEBUG
#define PTLog(fmt, ...)			PTLOG_MACRO(NO, PT_LOG_LEVEL, LOG_FLAG_VERBOSE, 0, fmt, ##__VA_ARGS__)
#else
#define PTLog(fmt, ...)			while(0){}
#endif
//==============================================================================



@interface PTLogger : NSObject <DDRegisteredDynamicLogging>

+ (DDLogLevel)ddLogLevel;
+ (void)ddSetLogLevel:(DDLogLevel)logLevel;

@end
