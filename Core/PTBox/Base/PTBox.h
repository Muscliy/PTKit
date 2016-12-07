//
//  PTBox.h
//  xmLife
//
//  Created by weihuazhang on 14/10/31.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef PTBoxInstanceImplementation
#define PTBoxInstanceImplementation                                                                \
    +(instancetype)sharedInstance                                                                  \
    {                                                                                              \
        static dispatch_once_t once;                                                               \
        static id __singleton__ = nil;                                                             \
        dispatch_once(&once, ^{ __singleton__ = [[self alloc] init]; });                           \
        return __singleton__;                                                                      \
    }

#undef PTBoxCommonImplementation
#define PTBoxCommonImplementation                                                                  \
    +(void)load                                                                                    \
    {                                                                                              \
        [self commonLoad];                                                                         \
    }                                                                                              \
    PTBoxInstanceImplementation

@interface PTBox : UICollectionViewCell

+ (void)commonLoad;
+ (NSString *)reuseIdentifier;

@end
