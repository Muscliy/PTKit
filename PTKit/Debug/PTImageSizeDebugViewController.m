//
//  PTImageSizeDebugViewController.m
//  PTKit
//
//  Created by LeeHu on 15/3/27.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTImageSizeDebugViewController.h"
#import "UIImage+Extents.h"

@interface PTImageSizeDebugViewController ()

@end

@implementation PTImageSizeDebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),
                                                      CGRectGetWidth(self.view.bounds))];
    [self.view addSubview:imageView];
}

- (NSArray *)configruationImageSize
{
    NSArray *sizes = @[ @"72", @"92", @"120", @"240", @"320", @"640", @"768", @"1080", @"1920" ];
    return sizes;
}

- (NSDictionary *)configruationViewSize
{
    NSString *shelfProductSize = NSStringFromCGSize(CGSizeMake(roundf(CGRectGetWidth(self.view.bounds)/3), roundf(CGRectGetWidth(self.view.bounds)/3)));
    NSDictionary *dict = @{@"快递员头像72*72":NSStringFromCGSize(CGSizeMake(72, 72)),
                           @"货架商品":shelfProductSize};
    return dict;
}

@end
