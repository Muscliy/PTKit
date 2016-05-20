//
//  PTSplashView.m
//  PTKit
//
//  Created by LeeHu on 12/17/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTSplashView.h"

@interface PTSplashView ()

@property (nonatomic, strong) UIImageView *launchImageView;


@end

@implementation PTSplashView

+ (void)show
{
	UIWindow *window = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
	window.windowLevel = UIWindowLevelStatusBar;
    [[self class] showInWindow:window];
}

+ (void)showInWindow:(UIWindow *)window
{
	PTSplashView *view = [[PTSplashView alloc] initWithFrame:window.bounds];
	[window addSubview:view];
	[window bringSubviewToFront:view];
	[view show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _launchImageView = [[UIImageView alloc] init];
        _launchImageView.image = [UIImage imageNamed:[self splashImageNameForOrientation:0]];
        [self addSubview:_launchImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _launchImageView.frame = self.bounds;
}

- (NSString *)splashImageNameForOrientation:(UIInterfaceOrientation)orientation
{
    CGSize viewSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    NSString *viewOrientation = @"Portrait"; //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;

    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);

        if (CGSizeEqualToSize(imageSize, viewSize) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return launchImage;
}

- (void)show
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [UIView animateWithDuration:2.0f
        delay:0.0f
        options:UIViewAnimationOptionBeginFromCurrentState
        animations:^{

          self.alpha = 0.0f;
          self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.4, 1.4, 1);

        }
        completion:^(BOOL finished) {
          [[UIApplication sharedApplication] setStatusBarHidden:NO];
          [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
          [self removeFromSuperview];
        }];
}

@end
