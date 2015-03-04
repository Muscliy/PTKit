//
//  PTQRCodeReaderOverlayView.m
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTQRCodeReaderOverlayView.h"
#import "PTOSMacro.h"
#import <QuartzCore/QuartzCore.h>
#import "PTCodeReaderUtil.h"
#define SCAN_LINE_ANIMATION @"SCAN_LINE_ANIMATION"


#define SCAN_WITH 211
#define SCAN_HEIGHT 151

#define PADDING 0
const CGFloat SCAN_LINE_ALPHA = 0.7f;


#define OS_PADDING (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0 ? 44 : 0)

#define TIPS_TEXT @"将取景框对准二维码，即可自动扫描。"
#define TIPS_TEXT_TOP @"将取景框对准二维码"
#define TIPS_TEXT_BOTTOM @"即可自动扫描"


#define TIPS_TEXT_NO_CAMERA @"你的设备不支持拍照，不能使用扫一扫。"
#define TIPS_TEXT_NO_CAMERA_IP5_TOP @"你的设备不支持拍照"
#define TIPS_TEXT_NO_CAMERA_IP5_BOTTOM @"不能使用扫一扫"

@interface PTQRCodeReaderOverlayView ()

-(void)addMaskView;

@end

@implementation PTQRCodeReaderOverlayView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addMaskView];
        isStopAnimation = NO;
    }
    return self;
}


-(void)addMaskView
{
    NSString *scanbgImage = @"qrcode_scan_bg_Green.png";
    int fixBg = 55;
    int tipLabY = 280;
    const int SCAN_RECT_SIZE = 250;
    CGRect scanRect = CGRectMake(50, 40, SCAN_RECT_SIZE , SCAN_RECT_SIZE - 25);
    
    if (IS_IPHONE_5)
    {
        fixBg = 25;
        tipLabY = 306;
        scanRect = CGRectMake(50, 71, SCAN_RECT_SIZE , SCAN_RECT_SIZE - 25);
        
        scanbgImage = @"qrcode_scan_bg_Green_iphone5.png";
    }
    
    //扫描线qrcode_scan_light_green
    UIImage *linemage = [UIImage imageNamed:@"qrcode_scan_light_green.png"];
    
    lineRectTop = CGRectMake(scanRect.origin.x, scanRect.origin.y - linemage.size.height/2, scanRect.size.width, linemage.size.height);
    lineRectBottom = CGRectMake(scanRect.origin.x, scanRect.origin.y + scanRect.size.height, scanRect.size.width, linemage.size.height);
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:lineRectTop];
    lineImageView.image = linemage;
    lineImageView.tag = 100;
    lineImageView.alpha = 0.0f;
    [self addSubview:lineImageView];
    
    // bg view
    CGRect bgRect = self.bounds;
    //bgRect.origin.y -= fixBg;
    UIImageView* bgview = [[UIImageView alloc] initWithFrame:bgRect];
    
    UIImage *bgImage = [UIImage imageNamed:scanbgImage];
    
    bgview.image = bgImage;
    
    //[bgview setClipsToBounds:YES];
    [bgview setContentMode:UIViewContentModeTopLeft];
    
    [self addSubview:bgview];
    
    
    //tip lib
    
    if (IS_IPHONE_5)
    {
        
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0,tipLabY + 20 , self.bounds.size.width, 20)];
        tipLab.font = [UIFont systemFontOfSize:16];
        tipLab.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        tipLab.backgroundColor = [UIColor clearColor];
        tipLab.text = TIPS_TEXT_TOP;
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.tag = 121401;
        [self addSubview:tipLab];
        
        UILabel *tipLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0,tipLab.frame.origin.y + 20 , self.bounds.size.width, 20)];
        tipLab2.font = [UIFont systemFontOfSize:16];
        tipLab2.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        tipLab2.backgroundColor = [UIColor clearColor];
        tipLab2.text = TIPS_TEXT_BOTTOM;
        tipLab2.textAlignment = NSTextAlignmentCenter;
        tipLab2.tag = 121402;
        [self addSubview:tipLab2];
    }
    else
    {
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0,tipLabY , self.bounds.size.width, 20)];
        tipLab.font = [UIFont systemFontOfSize:14];
        tipLab.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        tipLab.backgroundColor = [UIColor clearColor];
        tipLab.text = [self isCameraAvailable]?TIPS_TEXT:TIPS_TEXT_NO_CAMERA;
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.tag = 121403;
        [self addSubview:tipLab];
    }
    
}

-(void)setIsCameraAvailable:(BOOL)isCameraAvailable
{
    _isCameraAvailable = isCameraAvailable;
    
    if (IS_IPHONE_5)
    {
        UILabel *tipLab = (UILabel*)[self viewWithTag:121401];
        tipLab.text = _isCameraAvailable?TIPS_TEXT_TOP:TIPS_TEXT_NO_CAMERA_IP5_TOP;
        
        UILabel *tipLab2 = (UILabel*)[self viewWithTag:121402];
        tipLab2.text = _isCameraAvailable?TIPS_TEXT_BOTTOM:TIPS_TEXT_NO_CAMERA_IP5_BOTTOM;
    }
    else
    {
        UILabel *tipLab = (UILabel*)[self viewWithTag:121403];
        tipLab.text = _isCameraAvailable?TIPS_TEXT:TIPS_TEXT_NO_CAMERA;
    }
    
    
    
}


- (void)scan
{
    UIView *getView = [self viewWithTag:100];
    
    if (getView == nil)
    {
        return;
    }
    
    CAAnimation *animationOld = [getView.layer animationForKey:SCAN_LINE_ANIMATION];
    
    if (animationOld != nil) {
        return;
    }
    
    
    //移动动画
    CABasicAnimation *posAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    posAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width/2, lineRectTop.origin.y)];
    posAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width/2, lineRectBottom.origin.y)];
    posAnim.beginTime = 0.1;
    posAnim.duration = 3.9;
    
    
    //透明动画
    CABasicAnimation *opacityAnimBegin = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimBegin.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnimBegin.toValue = [NSNumber numberWithFloat:SCAN_LINE_ALPHA];
    opacityAnimBegin.beginTime = 0.1;
    opacityAnimBegin.duration = 0.2;
    opacityAnimBegin.fillMode = kCAFillModeForwards;
    
    
    //透明动画
    CABasicAnimation *opacityAnimEnd = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimEnd.fromValue = [NSNumber numberWithFloat:SCAN_LINE_ALPHA];
    opacityAnimEnd.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimEnd.beginTime = 3.5;
    opacityAnimBegin.duration = 0.5;
    opacityAnimBegin.fillMode = kCAFillModeForwards;
    
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:opacityAnimBegin,posAnim,opacityAnimEnd, nil];
    animGroup.duration = 4.0;
    animGroup.repeatCount = HUGE_VAL;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    
    // UIView *getView = [self viewWithTag:100];
    [getView.layer addAnimation:animGroup forKey:SCAN_LINE_ANIMATION];
    
    
    ///////////////////////////////////////////////////////////////
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDuration:2.0];
    //
    //    UIView *getView = [self viewWithTag:100];
    //
    //    getView.frame = lineRectTop;
    //    if (flag) {
    //        getView.frame = lineRectTop;
    //        flag = NO;
    //    }
    //    else
    //    {
    //        getView.frame = lineRectBottom;
    //        flag = YES;
    //
    //    }
    //    [UIView commitAnimations];
    
}



- (void)stopAnimation
{
    if (![self isCameraAvailable])
    {
        return;
    }
    
    UIView *getView = [self viewWithTag:100];
    //    getView.hidden = YES;
    [getView.layer removeAnimationForKey:SCAN_LINE_ANIMATION];
}

- (void)beginAnimation
{
    if (![self isCameraAvailable])
    {
        return;
    }
    
    UIView *getView = [self viewWithTag:100];
    //    getView.hidden = NO;
    //    lineImageView.alpha = 0.0f;
    [self scan];
}


- (void)addAnalyingView
{
    if (activityIndicatorView != nil)
    {
        return;
    }
    
    bgView = [[UIView alloc] initWithFrame:self.bounds];
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.19f green:0.20f blue:0.22f alpha:1.0f]; //#303237
    bgView.backgroundColor = backgroundColor;
    
    CGSize theSize = CGSizeMake(200, 50);
    CGRect theRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - theSize.width) / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64, theSize.width, theSize.height);
    analyLabel = [[UILabel alloc] initWithFrame:theRect];
    analyLabel.textAlignment = NSTextAlignmentCenter;
    analyLabel.backgroundColor = [UIColor clearColor];
    analyLabel.font = [UIFont systemFontOfSize:16];
    analyLabel.text = @"正在处理...";
    analyLabel.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:255.0f];
    [bgView addSubview:analyLabel];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [activityIndicatorView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64)];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView startAnimating];
    [bgView addSubview:activityIndicatorView];
    
    [self addSubview:bgView];
    
}

- (void)removeAnalyingView
{
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
    [analyLabel removeFromSuperview];
    [bgView removeFromSuperview];
    
    activityIndicatorView = nil;
    analyLabel = nil;
    bgView = nil;
}



@end
