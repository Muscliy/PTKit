//
//  PTCodeScanViewController.h
//  PTKit
//
//  Created by LeeHu on 15/2/11.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "parsedResults/ParsedResult.h"
#import "Decoder.h"

@protocol QRCodeScanDelegate;


@interface PTCodeScanViewController : UIViewController<DecoderDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    BOOL decoding;
    
    AVCaptureDevice *captureDevice;
    
    int32_t dwCount;
    time_t torchTime;
    time_t focusTime;
    
    uint8_t lastFocus;
    
    uint8_t lastRed;
    uint8_t lastGreen;
    uint8_t lastBlue;
    
    id monitorTarget;
    SEL monitorSelector;
    
    BOOL focusFailed;
    
    NSThread *decodeThread;

}
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic, retain ) NSSet *readers;
@property (nonatomic, weak) id<QRCodeScanDelegate> delegate;
@property (nonatomic, retain) ParsedResult *parsedResult;
@property (nonatomic,assign) BOOL isCameraAvailable;

- (void)initCapture;
- (void)stopCapture;

- (void)captureSessionstartRunning;
- (void)captureSessionstopRunning;

//- (BOOL)fixedFocus;
- (void)setTorch:(BOOL)status;
- (BOOL)torchIsOn;

-(BOOL)zbarDecode:(UIImage*)image;
-(BOOL)zxingDecode:(UIImage*)image;

-(BOOL)captureSessionisRunning;



@end

@protocol QRCodeScanDelegate <NSObject>
- (void)scanViewController:(PTCodeScanViewController*)controller didScanResult:(NSString *)result;
- (void)scanViewController:(PTCodeScanViewController*)controller failWithReason:(NSString *)reason;
- (void)scanViewControllerDidCancel:(PTCodeScanViewController*)controller;
@end
