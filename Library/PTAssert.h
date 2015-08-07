//
//  PTAssert.h
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLogger.h"
#import "PTBaseDefines.h"

BOOL IsInDebug(void);

#if DEBUG

#if TARGET_IPHONE_SIMULATOR

#define PTASSERT(xx)                                                           \
  {                                                                            \
    if (!(xx)) {                                                               \
      PTLog(@"PTASSERT failed: %s", #xx);                                      \
      if (IsInDebug()) {			\
								__asm__("int $3\n" : :);                                               \
      }                                                                        \
    }                                                                          \
  }                                                                            \
  ((void)0)

#else

#define PTASSERT(xx)                                                           \
  {                                                                            \
    if (!(xx)) {                                                               \
      PTLog(@"PTASSERT failed: %s", #xx);                                      \
      if (IsInDebug()) {                                                       \
        [[NSException exceptionWithName:NSInternalInconsistencyException       \
                                 reason:nil                                    \
                               userInfo:nil] raise];                           \
      }                                                                        \
    }                                                                          \
  }                                                                            \
  ((void)0)

#endif

#else

#define PTASSERT(xx)                                                           \
  {                                                                            \
    if (!(xx)) {                                                               \
      PTLogError(@"PTASSERT error: %s", #xx);                                  \
    }                                                                          \
  }                                                                            \
  ((void)0)

#endif
