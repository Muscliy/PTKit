//
//  PTCodeScanViewController.m
//  PTKit
//
//  Created by LeeHu on 15/2/11.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTCodeScanViewController.h"
#import "ResultParser.h"
#import "ParsedResult.h"
#import "ResultAction.h"
#import "TwoDDecoderResult.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"
#import "PTMediaDeviceAuthorize.h"
#import "UIDevice+Extents.h"
#import "UIImage+Extents.h"
#import "PTCodeReaderUtil.h"


const CGFloat CAMERA_SCALAR = 1.3;
const CGFloat OVERLAY_SCAN_RECT_OFFSET =  56.0f;
const CGFloat OVERLAY_SCAN_RECT_OFFSET_IP5 = 87.0f;
const int     FORCE_FOCUS_COUNT = 6;

const CGFloat B_TOOLBAR_H =  128.0f;


#define CAMERA_SCALAR_1280_720 1.5

#define CAMERA_SCALAR_IPOD4_640_480 1.7
#define CAMERA_SCALAR_IPHONE4_640_480 1.5

#define CAMERA_SCALAR_IPHONE3GS_640_480 1.9

#if !TARGET_IPHONE_SIMULATOR
#define HAS_AVFF 1
#endif


@interface PTCodeScanViewController ()
{
    int _focusCount;
    ZBarImageScanner *zbarScanner;
    CGFloat _previewZoom;
    
    DeviceType _devType;
    BOOL _bIPhone4_OR_IPod4G;
}
@property BOOL oneDMode;

@end

@implementation PTCodeScanViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        //检查是否有相机权限
        [self getCameraAvailable];
        
        self.oneDMode = NO;
        //self.wantsFullScreenLayout = YES;
        decoding = NO;
        
        zbarScanner = [ZBarImageScanner new];
        
        //取消所*****的识别
        [zbarScanner setSymbology: 0  config: ZBAR_CFG_ENABLE  to: 0];
        //只识别二维码
        [zbarScanner setSymbology: ZBAR_QRCODE                    config: ZBAR_CFG_ENABLE to: 1];
        
        _previewZoom = CAMERA_SCALAR_1280_720;
        
        _bIPhone4_OR_IPod4G = NO;
        _devType = [UIDevice deviceVersion];
        
        if (_devType == Device_iPhone4 || _devType == Device_iPodTouch4G )
        {
            _bIPhone4_OR_IPod4G = YES;
        }
        
        NSLog(@"判断是否是 iphone4 或 ipod4: result:%d: devtype:%d",_bIPhone4_OR_IPod4G,_devType);
    }
    return self;
}

- (void)dealloc {
    
    self.self.delegate = nil;
    
    [self stopCapture];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.wantsFullScreenLayout = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    decoding = YES;
    [self initCapture];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self stopCapture];
    if (![decodeThread isFinished]) {
        [decodeThread cancel];
    }
}


-(void)getCameraAvailable
{
    [PTMediaDeviceAuthorize isMediaDeviceAvailable:kMediaDeviceCamera completionHandler:^(BOOL granted) {
        
        self.isCameraAvailable = granted;
    }];
}


- (CGImageRef)CGImageRotated90:(CGImageRef)imgRef
{
    CGFloat angleInRadians = -90 * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, FALSE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
    CGColorSpaceRelease(colorSpace);
    //      CGContextTranslateCTM(bmContext,
    //                                                +(rotatedRect.size.width/2),
    //                                                +(rotatedRect.size.height/2));
    CGContextScaleCTM(bmContext, rotatedRect.size.width/rotatedRect.size.height, 1.0);
    CGContextTranslateCTM(bmContext, 0.0, rotatedRect.size.height);
    CGContextRotateCTM(bmContext, angleInRadians);
    //      CGContextTranslateCTM(bmContext,
    //                                                -(rotatedRect.size.width/2),
    //                                                -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             rotatedRect.size.width,
                                             rotatedRect.size.height),
                       imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    
    return (__bridge CGImageRef)(CFBridgingRelease(rotatedImage));
}


- (CGImageRef)CGImageRotated180:(CGImageRef)imgRef
{
    CGFloat angleInRadians = M_PI;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, FALSE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(width/2),
                          +(height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(width/2),
                          -(height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    
    return (__bridge CGImageRef)(CFBridgingRelease(rotatedImage));
}

// Decoderself.self.delegate methods
#pragma mark -
#pragma mark Decoderself.self.delegate methods
- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset{
    
}

- (void)decoder:(Decoder *)decoder decodingImage:(UIImage *)image usingSubset:(UIImage *)subset {
}

- (void)presentResultForString:(NSString *)resultString {
    self.parsedResult = [ResultParser parsedResultForString:resultString];
}

- (void)presentResultPoints:(NSArray *)resultPoints forImage:(UIImage *)image usingSubset:(UIImage *)subset {
    // simply add the points to the image view
    //NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:resultPoints];
    //[overlayView setPoints:mutableArray];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    [self presentResultForString:[twoDResult text]];
    //    [self presentResultPoints:[twoDResult points] forImage:image usingSubset:subset];
    // now, in a selector, call the self.self.delegate to give this overlay time to show the points
    //[self performSelector:@selector(notifyself.self.delegate:) withObject:[[twoDResult text]copy] afterDelay:0.0];
    
    [self performSelectorOnMainThread:@selector(notifydelegate:)
                           withObject:[[twoDResult text]copy]
                        waitUntilDone:YES];
}

- (void)notifydelegate:(id)text {
    if (self.self.delegate!=nil&& [self.self.delegate respondsToSelector:@selector(scanViewController:didScanResult:)] ) {
        [self.self.delegate scanViewController:self didScanResult:text];
    }
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason {
    //    decoder.self.self.delegate = nil;
    //    if (self.self.delegate!=nil&& [self.self.delegate respondsToSelector:@selector(scanViewController:failWithReason:)] ) {
    //        [self.self.delegate scanViewController:self failWithReason:reason];
    //    }
    
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point {
    
}


-(BOOL)checkPixel:(uint8_t)red andGreen:(uint8_t)green andBlue:(uint8_t)blue
{
    //NSLog(@"read %u  green %u   blue %u", red, green, blue);
    
    BOOL rst;
    
    if (abs(red-lastRed) > 5) {
        rst = NO;
    }
    else if (abs(green-lastGreen) > 5) {
        rst = NO;
    }
    else if (abs(blue-lastBlue) > 5) {
        rst = NO;
    }
    else {
        rst = YES;
    }
    
    lastRed = red;
    lastGreen = green;
    lastBlue = blue;
    
    return rst;
    
}

#pragma mark -
#pragma mark AVFoundation

- (void)initCapture {
    
    NSLog(@"%s start",__FUNCTION__);
    if (![self isCameraAvailable])
    {
        return;
    }
    
#if HAS_AVFF
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (nil == captureDevice)
    {
        return;
    }
    //对焦模式，自动对焦
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        if ([captureDevice lockForConfiguration:nil]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [captureDevice unlockForConfiguration];
        }
    }
    else if([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        if ([captureDevice lockForConfiguration:nil]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            [captureDevice unlockForConfiguration];
        }
    }
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if (nil == captureInput)
    {
        return;
    }
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    
    [captureOutput setVideoSettings:videoSettings];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    ///
    NSString* preset = nil;
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        isIPad() &&
        [captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540])
    {
        // NSLog(@"960");
        preset = AVCaptureSessionPresetiFrame960x540;
    }
    
    if (preset == nil)
    {
        if (_bIPhone4_OR_IPod4G)
        {
            if ([captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset640x480])
            {
                preset = AVCaptureSessionPreset640x480;
                
                _previewZoom = CAMERA_SCALAR_IPOD4_640_480;
                
                if (_devType == Device_iPhone4)
                {
                    _previewZoom = CAMERA_SCALAR_IPHONE4_640_480;
                }
            }
        }
    }
    
    if (preset == nil)
    {
        // NSLog(@"MED");
        preset = AVCaptureSessionPresetMedium;
        
        if ([captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720])
        {
            preset = AVCaptureSessionPreset1280x720;
            _previewZoom = CAMERA_SCALAR_1280_720;
        }
        else if ([captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset640x480])
        {
            preset = AVCaptureSessionPreset640x480;
            _previewZoom = CAMERA_SCALAR_IPHONE3GS_640_480;
        }
        else if ([captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetMedium])
        {
            preset = AVCaptureSessionPresetMedium;
        }
        else if ([captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetLow])
        {
            preset = AVCaptureSessionPresetLow;
        }
    }
    
    NSLog(@"capturePreset:%@: camera scalar:%f",preset,_previewZoom);
    self.captureSession.sessionPreset = preset;
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    if (!self.prevLayer) {
        self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    
    
    
    CGRect rc = self.view.bounds;
    const CGFloat zoom = _previewZoom;
    
    CGFloat zoomSizeW = (zoom - 1.0f)*rc.size.width;
    CGFloat zoomSizeH = (zoom - 1.0f)*rc.size.height;
    
    rc.origin.x -= zoomSizeW/2;
    rc.origin.y -= zoomSizeH/2;
    
    rc.size.width  += zoomSizeW;
    rc.size.height += zoomSizeH;
    
    CGFloat offsetScanRect  =(IS_IPHONE_5)?OVERLAY_SCAN_RECT_OFFSET_IP5:OVERLAY_SCAN_RECT_OFFSET;
    
    rc.origin.y -= offsetScanRect*zoom;
    
    self.prevLayer.frame = rc;
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.prevLayer];
    
    //    if (![captureSession isRunning]) {
    //        [self.captureSession startRunning];
    //    }
#endif
    
    NSLog(@"%s end",__FUNCTION__);
}

- (void)stopCapture
{
    if (![self isCameraAvailable])
    {
        return;
    }
    
    
    decoding = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(focusToCenter:) object:nil];
#if HAS_AVFF
    if (nil == _captureSession)
    {
        return;
    }
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
    
    if ([_captureSession.inputs count] > 0) {
        [_captureSession removeInput:[_captureSession.inputs objectAtIndex:0]];
    }
    
    if ([_captureSession.outputs count] > 0) {
        [_captureSession removeOutput:[_captureSession.outputs objectAtIndex:0]];
    }
    
    [self.prevLayer removeFromSuperlayer];
    self.prevLayer = nil;
    
    self.captureSession = nil;
    
    NSLog(@"stopCapture stop");
#endif
}

- (void)captureSessionstartRunning
{
    NSLog(@"%s start",__FUNCTION__);
    if (![self isCameraAvailable])
    {
        return;
    }
    
    decoding = YES;
    
#if HAS_AVFF
    
    if (nil == _captureSession)
    {
        return;
    }
    
    if (![_captureSession isRunning]) {
        [_captureSession startRunning];
    }
    
    NSLog(@"captureSessionstartRunning start");
    [self resetFocusParam];
    [self performSelector:@selector(focusToCenter:) withObject:nil afterDelay:0.1];
    
#endif
    NSLog(@"%s end",__FUNCTION__);
}

- (void)captureSessionstopRunning
{
    if (![self isCameraAvailable])
    {
        return;
    }
    
    
#if HAS_AVFF
    
    if (nil == _captureSession)
    {
        return;
    }
    
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
#endif
    
    NSLog(@"captureSessionstopRunning stop");
    [self resetFocusParam];
    
}


-(BOOL)captureSessionisRunning
{
    
#if HAS_AVFF
    return   [_captureSession isRunning];
#else
    return NO;
#endif
    
    
}

- (void)focusToCenter:(id)arg
{
    //return;
#if HAS_AVFF
    if (nil == _captureSession || nil == captureDevice)
    {
        return;
    }
    
    if (![_captureSession isRunning])
    {
        [self resetFocusParam];
        return;
    }
    
    if (_focusCount > FORCE_FOCUS_COUNT)
    {
        [self resetFocusParam];
    }
    
    //
    
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    
    if (_focusCount > 0)
    {
        focusMode = AVCaptureFocusModeAutoFocus;
    }
    
    
    CGPoint focusPt = CGPointMake(0.5f, 0.5f);
    
    if (captureDevice.focusPointOfInterestSupported)
    {
        //对焦模式，自动对焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        {
            if ([captureDevice lockForConfiguration:nil])
            {
                NSLog(@" timer focusToCenter:%zd",focusMode);
                [captureDevice setFocusPointOfInterest:focusPt];
                [captureDevice setFocusMode:focusMode];
                [captureDevice unlockForConfiguration];
            }
        }
        else if([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            if ([captureDevice lockForConfiguration:nil])
            {
                NSLog(@" timer focusToCenter:%zd",focusMode);
                [captureDevice setFocusPointOfInterest:focusPt];
                [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
                [captureDevice unlockForConfiguration];
            }
        }
        
        if (_focusCount > 0)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(focusToCenter:) object:nil];
            [self performSelector:@selector(focusToCenter:) withObject:nil afterDelay:3.5f];
        }
        
    }
    
    --_focusCount;
    
#endif
    
}

-(void)resetFocusParam
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(focusToCenter:) object:nil];
    _focusCount = FORCE_FOCUS_COUNT;
}


-(void)decodeCaptureOutputImageThread:(id)imageId
{
    @autoreleasepool
    {
        UIImage *image = (UIImage*)imageId;
        
        //NSLog(@"image11.w:%f,h:%f",image.size.width,image.size.height);
        
        decoding = [self zxingDecode:image ] == YES ? NO : YES;
        
        if (!decoding)
        {
            //UIImageWriteToSavedPhotosAlbum(image , nil, nil, nil);
            return;
        }
        
        //        if (captureDevice.adjustingFocus && _bIPhone4_OR_IPod4G)
        //        {
        //            return;
        //        }
        
        if ([[NSThread currentThread] isCancelled])
        {
            return ;
        }
        
        //尝试 zbar尝试
        UIImage* image2 = [PTCodeReaderUtil sharpenImage:image sharpness:0.6f];
        decoding = [self zbarDecode:image2] == YES ? NO : YES;
        
        if (!decoding)
        {
            //UIImageWriteToSavedPhotosAlbum(image12 , nil, nil, nil);
            return;
        }
        
        if ([[NSThread currentThread] isCancelled])
        {
            return ;
        }
        
        //缩小 两库尝试
        UIImage* image33 = [PTCodeReaderUtil scaleToSizeByAspectMax:image targetSize:180];
        UIImage* image3 =  [PTCodeReaderUtil sharpenImage:image33 sharpness:0.8f];
        //NSLog(@"image2.w:%f,h:%f",image2.size.width,image2.size.height);
        
        if ([[NSThread currentThread] isCancelled])
        {
            return ;
        }
        
        decoding = [self zxingDecode:image3 ] == YES ? NO : YES;
        
        if ([[NSThread currentThread] isCancelled])
        {
            return ;
        }
        
        if (decoding)
        {
            decoding = [self zbarDecode:image3] == YES ? NO : YES;
        }
        
        if (!decoding)
        {
            //UIImageWriteToSavedPhotosAlbum(image2 , nil, nil, nil);
            return;
        }
    }
}

-(BOOL)zbarDecode:(UIImage*)image
{
    if (image == nil )
    {
        return NO;
    }
    //analyLabel.text = @"zbarDecode 正在处理...";
    ZBarImage *zimg = [[ZBarImage alloc]
                       initWithCGImage: image.CGImage];
    
    if (zimg == nil)
    {
        return NO;
    }
    int nsyms = -1;
    ZBarSymbolSet* resultSyms = nil;
    
    @synchronized(zbarScanner)
    {
        nsyms = [zbarScanner scanImage: zimg];
        resultSyms = zbarScanner.results;
    }
    
    if(nsyms >= 0 && resultSyms != nil)
    {
        for(ZBarSymbol *sym in resultSyms)
        {
            NSString *result = sym.data;
            
            if (result == nil)
            {
                continue;
            }
            
            //decode
            const char* cStr = NULL;
            
            if ([result canBeConvertedToEncoding:NSShiftJISStringEncoding])
            {
                cStr= [result cStringUsingEncoding: NSShiftJISStringEncoding];
            }
            else if ([result canBeConvertedToEncoding:NSISOLatin1StringEncoding])
            {
                cStr= [result cStringUsingEncoding: NSISOLatin1StringEncoding];
            }
            
            if (cStr != NULL)
            {
                NSString* resultTemp = [NSString stringWithCString:cStr encoding:NSUTF8StringEncoding];
                
                if (resultTemp == nil)
                {
                    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    
                    resultTemp = [NSString stringWithCString:cStr encoding:gbkEncoding];
                }
                
                if (resultTemp != nil)
                {
                    result = resultTemp;
                }
            }
            
            //end
            
            
            
            if (result != nil /*&& result.length > 0*/)
            {
                NSLog(@"ZBarImagescanner 识别成功:::count:%d:result:%@",nsyms,result);
                [self performSelectorOnMainThread:@selector(notifydelegate:)
                                       withObject:result
                                    waitUntilDone:YES];
                return YES;
            }
            
         }
    }
    
     NSLog(@"ZBarImagescanner 识别失败");
    return NO;
    
}

-(BOOL)zxingDecode:(UIImage*)image
{
    if (image == nil)
    {
        return NO;
    }
    
    if ([[NSThread currentThread] isCancelled])
    {
        return NO;
    }
    
    Decoder *d = [[Decoder alloc] init];
    d.readers = self.readers;
    d.self.self.delegate = self;
    
    BOOL bOK = [d decodeImage:image ] ;
    
    if (bOK)
    {
        NSLog(@"ZXing 识别成功::result:");
    }
    else
    {
          NSLog(@"ZXing 识别失败::result:");
    }
    
    return bOK;
}

#if HAS_AVFF
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    //    /////////////////////////////////
    //    static int outCount = -1;
    //    ++outCount;
    //
    //    //NSLog(@"视频采集回调速度：%d",outCount);
    //
    //    if (outCount%3 != 0)
    //    {
    //        return;
    //    }
    //    outCount = 0;
    //
    //    //////////////////////////////////
    
    if (!decoding)
    {
        return;
    }
    
    if (decodeThread != nil && ![decodeThread isFinished])
    {
        // NSLog(@"decode is not finished");
        return;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    /*Get information about the image*/
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t widthPix = CVPixelBufferGetWidth(imageBuffer);
    size_t heightPix = CVPixelBufferGetHeight(imageBuffer);
    
    uint8_t* baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    void* free_me = 0;
    if (true) { // iOS bug?
        uint8_t* tmp = baseAddress;
        int bytes = bytesPerRow*heightPix;
        free_me = baseAddress = (uint8_t*)malloc(bytes);
        baseAddress[0] = 0xdb;
        memcpy(baseAddress,tmp,bytes);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext =
    CGBitmapContextCreate(baseAddress, widthPix, heightPix, 8, bytesPerRow, colorSpace,
                          kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
    
    CGImageRef capture = CGBitmapContextCreateImage(newContext);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    free(free_me);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    // CGRect cropRect = [overlayView cropRect];
    CGRect cropRect = self.view.bounds;
    
    
    // N.B.
    // - Won't work if the overlay becomes uncentered ...
    // - iOS always takes videos in landscape
    // - images are always 4x3; device is not
    // - iOS uses virtual pixels for non-image stuff
    
    {
        float height = CGImageGetHeight(capture);
        float width = CGImageGetWidth(capture);
        
        float tmp = cropRect.size.width;
        cropRect.size.width = cropRect.size.height;
        cropRect.size.height = tmp;
        
        
        CGFloat zoomImageW = width/cropRect.size.width;
        CGFloat zoomImageH = height/cropRect.size.height;
        
        CGFloat zoomImage = zoomImageW > zoomImageH?zoomImageH:zoomImageW;
        
        cropRect.size.width *= zoomImage;
        cropRect.size.height *= zoomImage;
        
        cropRect.origin.x = (width-cropRect.size.width)/2;
        cropRect.origin.y = (height-cropRect.size.height)/2;
        
        CGRect noScalarRect = cropRect;
        
        ////
        const CGFloat zoom = _previewZoom;
        
        CGFloat zoomSizeW = cropRect.size.width - cropRect.size.width/zoom;
        CGFloat zoomSizeH = cropRect.size.height - cropRect.size.height/zoom;
        
        cropRect.origin.x += zoomSizeW/2;
        cropRect.origin.y += zoomSizeH/2;
        
        cropRect.size.width -= zoomSizeW;
        cropRect.size.height -= zoomSizeH;
        
        CGFloat offsetScanRect  = (IS_IPHONE_5)?OVERLAY_SCAN_RECT_OFFSET_IP5:OVERLAY_SCAN_RECT_OFFSET;
        offsetScanRect = (offsetScanRect/self.view.bounds.size.height)* noScalarRect.size.width;
        
        cropRect.origin.x += offsetScanRect;
        
        CGFloat bToolbarH  = (IS_IPHONE_5)?B_TOOLBAR_H+20:B_TOOLBAR_H;
        CGFloat  barH = (bToolbarH/self.view.bounds.size.height)*cropRect.size.width;
        cropRect.size.width -= barH;
    }
    
    
    CGImageRef newImage = CGImageCreateWithImageInRect(capture, cropRect);
    CGImageRelease(capture);
    UIImage *scrn = [[UIImage alloc] initWithCGImage:newImage];
    CGImageRelease(newImage);
    
    
    //        static int decodeCount = 0;
    //解码过程放在子线程去做，避免阻塞UI线程 add by aimengou
    if (decodeThread == nil)
    {
        //            ++decodeCount;
        //            NSLog(@"视频采集回调处理速度：第%d帧，第%d次",outCount,decodeCount);
        decodeThread = [[NSThread alloc] initWithTarget:self selector:@selector(decodeCaptureOutputImageThread:) object:scrn];
        [decodeThread start];
    }
    
    if ([decodeThread isFinished])
    {
        
        //            ++decodeCount;
        //            NSLog(@"视频采集回调处理速度：第%d帧，第%d次",outCount,decodeCount);
        
        decodeThread = [[NSThread alloc] initWithTarget:self selector:@selector(decodeCaptureOutputImageThread:) object:scrn];
        [decodeThread start];
    }
}
#endif



#pragma mark - Torch

- (void)setTorch:(BOOL)status {
#if HAS_AVFF
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            if ( status ) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
        [device unlockForConfiguration];
        
    }
#endif
}

- (BOOL)torchIsOn {
#if HAS_AVFF
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        BOOL isOn = NO;
        
        [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            isOn = [device torchMode] == AVCaptureTorchModeOn;
        }
        [device unlockForConfiguration];
        
        return isOn;
    }
#endif
    return NO;
}

//////

// Gross, I know. But you can't use the device idiom because it's not iPad when running
// in zoomed iphone mode but the camera still acts like an ipad.
#if HAS_AVFF
static bool isIPad() {
    static int is_ipad = -1;
    if (is_ipad < 0) {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0); // Get size of data to be returned.
        char *name = malloc(size);
        sysctlbyname("hw.machine", name, &size, NULL, 0);
        NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
        free(name);
        is_ipad = [machine hasPrefix:@"iPad"];
    }
    return !!is_ipad;
}
#endif

@end
