//
//  PTBoxManager.h
//  xmLife
//
//  Created by weihuazhang on 14/10/31.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTCollectionViewLayout.h"
#import "PTBoxGroup.h"
#import "PTBox.h"

@interface PTBoxManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerBoxGroup:(PTBoxGroup *)boxGroup forType:(id)types;
- (PTBoxGroup *)boxGroupForType:(id)type;

@end
