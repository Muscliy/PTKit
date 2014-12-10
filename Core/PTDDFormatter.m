//
//  PTDDFormatter.m
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTDDFormatter.h"

@implementation PTDDFormatter

- (instancetype)init {
	if (self = [super init]) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
	}
	return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	NSString *logLevel;
	switch (logMessage.flag) {
		case LOG_FLAG_ERROR : logLevel = @"<Err!>"; break;
		case LOG_FLAG_WARN  : logLevel = @"<Warn>"; break;
		case LOG_FLAG_INFO  : logLevel = @"<Info>"; break;
		case LOG_FLAG_DEBUG : logLevel = @"<Debug>"; break;
		default             : logLevel = @"<Verb>"; break;
			
	}
	
	NSString *dateAndTime = [dateFormatter stringFromDate:(logMessage.timestamp)];
	NSString *logMsg = logMessage.message;
	
	return [NSString stringWithFormat:@"%@(%@)%@[L:%tu]%@ %@", dateAndTime, logMessage.threadID, logMessage.function, logMessage.line, logLevel, logMsg];
}

@end
