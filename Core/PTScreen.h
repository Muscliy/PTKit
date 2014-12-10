//
//  PTScreen.h
//  PTKit
//
//  Created by LeeHu on 14/11/25.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTScreen : NSObject

/*
 * The scale of the main screen.
 *
 * Safe to call from any thread.
 */
+ (CGFloat)scale;

/*
 * The overall screen size in fixed orientation.
 *
 * Safe to call from any thread.
 */
+ (CGSize)size;

/**
 * The overall screen height
 *
 * Safe to call from any thread.
 */
+ (CGFloat)screenHeight;

/*
 * Screen size in current orientation minus status bar.
 *
 * Only safe to call from Main thread.
 */
+ (CGSize)sizeInOrientation;

@end
