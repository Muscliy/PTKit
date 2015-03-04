//
//  PTQRCodeReaderViewController.m
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTQRCodeReaderViewController.h"
#import "PTNavigationBar.h"
#import <AVFoundation/AVFoundation.h>
#import "PTQRCodeReaderOverlayView.h"
#import "PTMediaDeviceAuthorize.h"
#import "PTRectMacro.h"
#import "UIBarButtonItem+Extents.h"

@interface PTQRCodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIColor *previousNavBarColor;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *captureInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *captureMetadataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;
@property (nonatomic, strong) PTQRCodeReaderOverlayView *overlayView;
@property (nonatomic, assign) BOOL isCameraAvailable;
@property (nonatomic, strong) UIActivityIndicatorView *activeIndicator;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, assign) BOOL success;

@end

@implementation PTQRCodeReaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.success = NO;
    
    UIColor *backgroundColor =
    [UIColor colorWithRed:0.19f green:0.20f blue:0.22f alpha:1.0f]; //#303237
    self.view.backgroundColor = backgroundColor;
    
    [self getCameraAvailable];
    [self setUI];
    if (self.isCameraAvailable) {
        [self initCapture];
    }
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem leftIconItemTarget:self
                                 action:@selector(leftBarButtonItemOnClick)
                             normalIcon:@"icon_back"
                          highlightIcon:@"icon_back_in"];

}

- (void)leftBarButtonItemOnClick
{
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.success = NO;
    [self setCurrentNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.success = YES;
    [super viewWillDisappear:animated];
    [self restorePreviousNavBar];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self endScan];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.overlayView.isCameraAvailable = self.isCameraAvailable;
    [self getCameraAvailable];
    if (self.isCameraAvailable) {
        [self startCaptureRunning];
        if (_overlayView != nil) {
            [self.view addSubview:_overlayView];
        }
    }
    [(PTQRCodeReaderOverlayView *)self.overlayView beginAnimation];
}

- (void)setUI
{
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    //[self.view addSubview:_highlightView];
    
    CGFloat activeIndicatorY = IS_IPHONE_5 ? 160.0f : 136.0f;
    
    CGFloat ios7OffsetBarH = 64;
    activeIndicatorY += ios7OffsetBarH;
    _activeIndicator = [[UIActivityIndicatorView alloc]
                        initWithFrame:CGRectMake(115.0f, activeIndicatorY, 30.0f, 30.0f)];
    
    [_activeIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_activeIndicator startAnimating];
    
    [self.view addSubview:self.activeIndicator];
    CGRect activeRect = self.activeIndicator.frame;
    CGSize theSize = CGSizeMake(90, 50);
    CGRect theRect = CGRectMake(activeRect.origin.x + activeRect.size.width - 10,
                                activeRect.origin.y - 9, theSize.width, theSize.height);
    _loadingLabel = [[UILabel alloc] initWithFrame:theRect];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.font = [UIFont systemFontOfSize:16];
    _loadingLabel.text = @"准备中...";
    _loadingLabel.textColor = [UIColor colorWithRed:200.0f / 255.0f
                                              green:200.0f / 255.0f
                                               blue:200.0f / 255.0f
                                              alpha:1.0f];
    _loadingLabel.tag = 100;
    
    [self.view addSubview:_loadingLabel];
    
    PTQRCodeReaderOverlayView *aOverlayView =
    [[PTQRCodeReaderOverlayView alloc] initWithFrame:self.view.bounds];
    self.overlayView = aOverlayView;
}

- (void)addAnalyingView
{
    if (_overlayView != nil) {
        [self.view addSubview:_overlayView];
    }
    
    [self.overlayView addAnalyingView];
}

- (void)removeAnalyingView
{
    [self.overlayView removeAnalyingView];
}

- (void)initCapture
{
    _captureSession = [[AVCaptureSession alloc] init];
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [self.captureDevice lockForConfiguration:nil];
    if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [self.captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    [self.captureDevice unlockForConfiguration];
    
    NSError *error = nil;
    
    _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    if (_captureInput) {
        [_captureSession addInput:_captureInput];
    } else {
        NSLog(@"error %@", error);
    }
    
    _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_captureSession addOutput:_captureMetadataOutput];
    
    _captureMetadataOutput.metadataObjectTypes = @[ AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeUPCECode];
    
    self.capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _capturePreviewLayer.frame = self.view.bounds;
    _capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view bringSubviewToFront:_highlightView];
}

- (void)startCaptureRunning
{
    [self.view.layer addSublayer:_capturePreviewLayer];
    [_captureSession startRunning];
}

- (void)stopCaptureRunning
{
    [_captureSession stopRunning];
}

- (void)restartScan
{
    [self removeAnalyingView];
    [self startCaptureRunning];
    [(PTQRCodeReaderOverlayView *)self.overlayView beginAnimation];
}

- (void)endScan
{
    [self.overlayView stopAnimation];
    [self.overlayView removeFromSuperview];
    [_capturePreviewLayer removeFromSuperlayer];
    [self stopCaptureRunning];
}

- (void)setCurrentNavBar
{
    PTNavigationBar *navBar = (PTNavigationBar *)self.navigationController.navigationBar;
    self.previousNavBarColor = navBar.color;
    UIColor *color =
    [UIColor colorWithRed:35.0 / 255.0 green:35.0 / 255.0 blue:35.0 / 255.0 alpha:0.8];
    [navBar setNavigationBarWithColor:color];
}

- (void)restorePreviousNavBar
{
    PTNavigationBar *navBar = (PTNavigationBar *)self.navigationController.navigationBar;
    [navBar setNavigationBarWithColor:self.previousNavBarColor];
}

- (void)getCameraAvailable
{
    [PTMediaDeviceAuthorize isMediaDeviceAvailable:kMediaDeviceCamera
                      completionHandler:^(BOOL granted) { self.isCameraAvailable = granted; }];
}

static SystemSoundID qrcode_match_id = 0;
- (void)playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"qrcode_match" ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath : path],
                                         &qrcode_match_id);
        AudioServicesPlaySystemSound(qrcode_match_id);
    }
    
    AudioServicesPlaySystemSound(
                                 qrcode_match_id); //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = _captureMetadataOutput.metadataObjectTypes;
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)
                [_capturePreviewLayer transformedMetadataObjectForMetadataObject:
                 (AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                if (self.success) {
                    return;
                }
                self.success = YES;
                [self playSound];
                [self endScan];
                if ([self.delegate respondsToSelector:@selector(QRCodeReaderView:relsutCode:)]) {
                    [self.delegate QRCodeReaderView:self relsutCode:detectionString];
                }
                break;
            }
        }
    }
    
    _highlightView.frame = highlightViewRect;
}

@end
