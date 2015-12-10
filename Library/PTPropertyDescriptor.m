//
//  PTPropertyDescriptor.m
//  PTKit
//
//  Created by LeeHu on 12/1/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTPropertyDescriptor.h"

@implementation PTPropertyDescriptor

- (instancetype)initWithDefaultsKey:(NSString *)defaultsKey type:(NSString *)type isSetter:(BOOL)isSetter
{
	if ((self = [super init])) {
		_defaultsKey = defaultsKey;
		_type = type;
		_isSetter = isSetter;
	}
	return self;
}

@end
