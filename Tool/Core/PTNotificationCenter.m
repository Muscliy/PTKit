//
//  PTNotificationCenter.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTNotificationCenter.h"

@interface PTNotificationCenter () {
	NSHashTable *delegates;
}

@end

@implementation PTNotificationCenter

static PTNotificationCenter *instance = nil;

+ (PTNotificationCenter *)defaultCenter
{
	@synchronized(self)
	{
	if (instance == nil) {
		instance = [[PTNotificationCenter alloc] init];
		return instance;
	}
	}
	return instance;
}

- (instancetype)init
{
	if ((self = [super init])) {
		delegates = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
	}
	return self;
}

- (void)addDeletegate:(id<PTAppDelegate>)d
{
	[delegates addObject:d];
}

- (void)removeDeletegate:(id<PTAppDelegate>)d
{
	[delegates removeObject:d];
}

- (NSHashTable *)getDelegateCopy
{
	return [delegates copy];
}

- (void)notifySignout
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onSignout)]) {
				[d onSignout];
			}
		}
	});
}

- (void)notifyKickout
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onKickout)]) {
				[d onKickout];
			}
		}
	});
}

- (void)notifyUserBlocked
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onUserBlocked)]) {
				[d onUserBlocked];
			}
		}
	});
}

- (void)notifyDeviceBlocked
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onDeviceBlocked)]) {
				[d onDeviceBlocked];
			}
		}
	});
}

- (void)notifyLoginSuccess
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onLoginSuccess)]) {
				[d onLoginSuccess];
			}
		}
	});
}

- (void)notifyNetworkError
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onNetworkError)]) {
				[d onNetworkError];
			}
		}
	});
}

- (void)notifyNetWorkFailed
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onNetworkFailed)]) {
				[d onNetworkFailed];
			}
		}
	});
}

- (void)notifyNetWorkSuccess
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSHashTable *delegatesCopy = [self getDelegateCopy];
		for (id<PTAppDelegate> d in delegatesCopy) {
			if ([d respondsToSelector:@selector(onNetworkSuccess)]) {
				[d onNetworkSuccess];
			}
		}
	});
}


@end
