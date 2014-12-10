//
//  PTAssert.m
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTAssert.h"
#import <unistd.h>
#import <sys/sysctl.h>

static BOOL AmIBeingDebugged()
{
	int                 junk;
	int                 mib[4];
	struct kinfo_proc   info;
	size_t              size;
	
	info.kp_proc.p_flag = 0;
	
	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();
	
	size = sizeof(info);
	junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
	assert(junk == 0);
	
	return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}


BOOL IsInDebug(void){
	return AmIBeingDebugged();
}