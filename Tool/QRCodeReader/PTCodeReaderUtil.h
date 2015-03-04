//
//  PTCodeReaderUtil.h
//  PTKit
//
//  Created by LeeHu on 15/2/11.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface PTCodeReaderUtil : NSObject

+ (UIImage *)sharpenImage:(UIImage *)srcImg sharpness:(CGFloat)sharpness;

+ (UIImage *)scaleToSizeByAspectMax:(UIImage *)image targetSize:(CGFloat)targetSize;

+ (BOOL) torchAvailable;

+(BOOL) isConnectionAvailable;


+(UIImage*) imagesNamedFromCustomBundle:(NSString *)name;

@end
