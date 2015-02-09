//
//  PTQRCodeReaderOverlayView.m
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTQRCodeReaderOverlayView.h"
#import "PTOSMacro.h"

#define SCAN_WITH 211
#define SCAN_HEIGHT 151

#define PADDING 0

#define OS_PADDING (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0 ? 44 : 0)

@interface PTQRCodeReaderOverlayView ()

@property (nonatomic, strong) UIImageView *celarImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) PTQRCodeReaderOverlayer *overLayer;

@end

@implementation PTQRCodeReaderOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.overLayer = [PTQRCodeReaderOverlayer layer];
        _bgView = [[UIView alloc] init];
        [_bgView.layer addSublayer:self.overLayer];

        [self addSubview:_bgView];
        _scanLine = [[UIImageView alloc] init];
        _scanLine.image = [UIImage imageNamed:@"scan_ray"];
        [self addSubview:_scanLine];

        _celarImageView = [[UIImageView alloc] init];
        _celarImageView.image = [UIImage imageNamed:@"fram_scan"];
        [self addSubview:_celarImageView];

        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.text = @"将条形码放入框内，即可自动扫描";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = [UIColor whiteColor];

        [self addSubview:_tipLabel];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.frame = self.bounds;
    self.overLayer.bounds = self.bounds;
    self.overLayer.position =
        CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    [self.overLayer setNeedsDisplay];
    _scanLine.frame = CGRectMake(0, 0, SCAN_WITH, 5.5);
    _scanLine.center = CGPointMake(CGRectGetWidth(self.bounds) / 2,
                                   CGRectGetHeight(self.bounds) / 2 - 102.5 +
                                       CGRectGetHeight(_scanLine.frame) / 2 - PADDING + OS_PADDING);
    _celarImageView.frame = CGRectMake(0, 0, SCAN_WITH, SCAN_HEIGHT);
    _celarImageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2,
                                         CGRectGetHeight(self.bounds) / 2 - PADDING + OS_PADDING);
    _tipLabel.frame =
        CGRectMake(CGRectGetMinX(_celarImageView.frame), CGRectGetMaxY(_celarImageView.frame) + 15,
                   CGRectGetWidth(_celarImageView.frame), 20);
}

- (void)addMaskView
{
}

- (void)stopAnimation
{
    if (!self.isCameraAvailable) {
        return;
    }
}

- (void)beginAnimation
{
    if (!self.isCameraAvailable) {
        [self addAnalyingView];
        analyLabel.text = @"无法扫描，请在\"设置-隐私-相机\"中允许访问相机。";
        [activityIndicatorView stopAnimating];
        return;
    }

    [self scan];
}

- (void)addAnalyingView
{
    if (activityIndicatorView != nil) {
        return;
    }

    tipView = [[UIView alloc] initWithFrame:self.bounds];

    UIColor *backgroundColor =
        [UIColor colorWithRed:0.19f green:0.20f blue:0.22f alpha:1.0f]; //#303237
    tipView.backgroundColor = backgroundColor;

    CGSize theSize = CGSizeMake(200, 50);
    CGRect theRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - theSize.width) / 2,
                                [UIScreen mainScreen].bounds.size.height / 2 - 64, theSize.width,
                                theSize.height);
    analyLabel = [[UILabel alloc] initWithFrame:theRect];
    analyLabel.textAlignment = NSTextAlignmentCenter;
    analyLabel.backgroundColor = [UIColor clearColor];
    analyLabel.font = [UIFont systemFontOfSize:16];
    analyLabel.text = @"正在处理...";
    analyLabel.numberOfLines = 0;
    analyLabel.lineBreakMode = NSLineBreakByCharWrapping;
    analyLabel.textAlignment = NSTextAlignmentCenter;
    analyLabel.textColor = [UIColor colorWithRed:200.0f / 255.0f
                                           green:200.0f / 255.0f
                                            blue:200.0f / 255.0f
                                           alpha:255.0f];
    [tipView addSubview:analyLabel];

    activityIndicatorView =
        [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [activityIndicatorView
        setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2,
                              [UIScreen mainScreen].bounds.size.height / 2 - 64)];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView startAnimating];
    [tipView addSubview:activityIndicatorView];

    [self addSubview:tipView];
}

- (void)removeAnalyingView
{
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
    [analyLabel removeFromSuperview];
    [tipView removeFromSuperview];

    activityIndicatorView = nil;
    analyLabel = nil;
    tipView = nil;
}

- (void)scan
{
    _scanLine.alpha = 0.0;
    _scanLine.center = CGPointMake(CGRectGetWidth(self.bounds) / 2,
                                   CGRectGetHeight(self.bounds) / 2 - SCAN_HEIGHT / 2 +
                                       CGRectGetHeight(_scanLine.frame) / 2 - PADDING + OS_PADDING);
}

- (void)setAnimation
{
    PTWeakSelf;
    self.scanLine.alpha = 1.0;
    [UIView animateWithDuration:2.0
        animations:^{
            self.scanLine.center = CGPointMake(CGRectGetWidth(self.bounds) / 2,
                                               CGRectGetHeight(self.bounds) / 2 + SCAN_HEIGHT / 2 -
                                                   PADDING + OS_PADDING);
        }
        completion:^(BOOL finished) {
            PTStrongSelf;
            [self scan];
        }];
}

@end

@implementation PTQRCodeReaderOverlayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGRect centerRect =
        CGRectMake(CGRectGetWidth(self.bounds) / 2 - SCAN_WITH / 2,
                   CGRectGetHeight(self.bounds) / 2 - SCAN_HEIGHT / 2 - PADDING + OS_PADDING,
                   SCAN_WITH, SCAN_HEIGHT);

    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor);
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathAddRect(progressPath, NULL, self.bounds);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(ctx, progressPath);
    CGContextFillPath(ctx);
    CGPathRelease(progressPath);

    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextAddRect(ctx, centerRect);
    CGContextFillPath(ctx);
}


@end
