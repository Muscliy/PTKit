//
//  PTImageBrowserUtil.h
//  PTKit
//
//  Created by LeeHu on 15/3/3.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTImageBrowserProtocol.h"

@interface PTImageBrowserUtil : NSObject<PTImageBrowserUtil>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) NSURL *imageURL;

+ (PTImageBrowserUtil *)createWithImage:(UIImage *)image;
+ (PTImageBrowserUtil *)createWithURL:(NSURL *)url;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithURL:(NSURL *)url;


@end
