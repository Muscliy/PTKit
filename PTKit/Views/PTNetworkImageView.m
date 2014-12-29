//
//  PTNetworkImageView.m
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTNetworkImageView.h"
#import "PTAssert.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation PTNetworkImageView

- (void)setNetworkImage:(id)data
{
    [self setNetworkImage:data placeholderImage:nil];
}

- (void)setNetworkImage:(id)data placeholderImage:(NSString *)defaultIcon
{
    PTASSERT([NSThread mainThread]);
    if (!data) {
        self.image = [UIImage imageNamed:defaultIcon];
    } else if ([data isKindOfClass:[NSString class]]) {
        NSString *url = (NSString *)data;
        if ([url hasPrefix:@"res://img/"]) {
            NSString *iconName = [url substringFromIndex:10];
            [self sd_cancelCurrentImageLoad];
            self.image = [UIImage imageNamed:iconName];
        } else {
            [self
             sd_setImageWithURL:[NSURL URLWithString:data]
             placeholderImage:[UIImage imageNamed:defaultIcon]
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                         NSURL *imageURL) {
                 if (cacheType == SDImageCacheTypeNone) {
                     self.alpha = 0;
                     [UIView animateWithDuration:0.25 animations:^{ self.alpha = 1; }];
                 }
             }];
        }
    } else if ([data isKindOfClass:[UIImage class]]) {
        [self sd_cancelCurrentImageLoad];
        [self setImage:data];
    } else if ([data isKindOfClass:[NSData class]]) {
        [self sd_cancelCurrentImageLoad];
        [self setImage:[UIImage imageWithData:(NSData *)data]];
    }

}

@end
