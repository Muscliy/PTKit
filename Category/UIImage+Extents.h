//
//  UIImage+Extents.h
//  PTKit
//
//  Created by LeeHu on 15/2/9.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extents)

+ (UIImage *)imageNamed:(NSString *)name edge:(UIEdgeInsets)edge;
- (UIImage *)imageResize:(UIEdgeInsets)edge;


@end
