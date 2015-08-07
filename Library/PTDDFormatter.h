//
//  PTDDFormatter.h
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface PTDDFormatter : NSObject<DDLogFormatter> {
	NSDateFormatter *dateFormatter;
}

@end
