//
//  PTBoxManagerAdapter.h
//  xmLife
//
//  Created by weihuazhang on 14/11/5.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTCollectionViewLayout.h"
#import "PTBoxGroup.h"

@interface PTBoxManagerAdapter : NSObject <PTCollectionViewLayoutDelegate>

@property (nonatomic, strong) NSArray *types;
@property (nonatomic, weak) id<PTBoxDataSource> dataSource;

@end
