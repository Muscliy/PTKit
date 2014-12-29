//
//  PTCodeSnippet.h
//  PTKit
//
//  Created by LeeHu on 14/12/11.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "EXTScope.h"

#ifndef PTKit_PTCodeSnippet_h
#define PTKit_PTCodeSnippet_h

#undef PTSingletonInterface
#define PTSingletonInterface +(instancetype)sharedInstance;

#undef PTSingletonImplementation
#define PTSingletonImplementation                                                    \
    +(instancetype)sharedInstance                                                    \
    {                                                                                \
        static dispatch_once_t once;                                                 \
        static id __singleton__ = nil;                                               \
        dispatch_once(&once, ^{ __singleton__ = [[self alloc] init]; }               \
        return __singleton__;                                                        \
    }

#undef PTWeak
#define PTWeak(...) @weakify(__VA_ARGS__)
#define PTWeakSelf PTWeak(self);

#undef PTStrong
#define PTStrong(...) @strongify(__VA_ARGS__)
#define PTStrongSelf PTStrong(self);

#endif
