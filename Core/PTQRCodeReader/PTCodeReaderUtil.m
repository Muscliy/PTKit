//
//  PTCodeReaderUtil.m
//  PTKit
//
//  Created by LeeHu on 15/2/11.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTCodeReaderUtil.h"
#import "UIDevice+Extents.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <Accelerate/Accelerate.h>

//

#pragma mark - Sharpen kernels

/* Number of components for an ARGB pixel (Alpha / Red / Green / Blue) = 4 */
#define kNyxNumberOfComponentsPerARBGPixel 4

/* Minimun value for a pixel component */
#define kNyxMinPixelComponentValue (UInt8)0
/* Maximum value for a pixel component */
#define kNyxMaxPixelComponentValue (UInt8)255



/* vImage kernel */
static int16_t __s_sharpen_kernel_3x3[9] = {
    -1, -1, -1,
    -1, 9, -1,
    -1, -1, -1
};
/* vDSP kernel */
static float __f_sharpen_kernel_3x3[9] = {
    -1.0f, -1.0f, -1.0f,
    -1.0f, 9.0f, -1.0f,
    -1.0f, -1.0f, -1.0f
};

static CGColorSpaceRef __rgbColorSpace = NULL;


CGColorSpaceRef NYXGetRGBColorSpace(void)
{
    if (!__rgbColorSpace)
    {
        __rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    }
    return __rgbColorSpace;
}


static CGContextRef NYXCreateARGBBitmapContext(const size_t width, const size_t height, const size_t bytesPerRow)
{
    /// Use the generic RGB color space
    /// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
    /// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8/*Bits per component*/, bytesPerRow, NYXGetRGBColorSpace(), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    return bmContext;
}


static  UIImage* sharpenWithBias(UIImage *srcImg,NSInteger bias)
{
    /// Create an ARGB bitmap context
    const size_t width = srcImg.size.width;
    const size_t height = srcImg.size.height;
    const size_t bytesPerRow = width * kNyxNumberOfComponentsPerARBGPixel;
    CGContextRef bmContext = NYXCreateARGBBitmapContext(width, height, bytesPerRow);
    if (!bmContext)
        return nil;
    
    /// Draw the image in the bitmap context
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, srcImg.CGImage);
    
    /// Grab the image raw data
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data)
    {
        CGContextRelease(bmContext);
        return nil;
    }
    
    /// vImage (iOS 5)
    if ((&vImageConvolveWithBias_ARGB8888))
    {
        const size_t n = sizeof(UInt8) * width * height * 4;
        void* outt = malloc(n);
        vImage_Buffer src = {data, height, width, bytesPerRow};
        vImage_Buffer dest = {outt, height, width, bytesPerRow};
        vImageConvolveWithBias_ARGB8888(&src, &dest, NULL, 0, 0, __s_sharpen_kernel_3x3, 3, 3, 1/*divisor*/, bias, NULL, kvImageCopyInPlace);
        
        memcpy(data, outt, n);
        
        free(outt);
    }
    else
    {
        const size_t pixelsCount = width * height;
        const size_t n = sizeof(float) * pixelsCount;
        float* dataAsFloat = malloc(n);
        float* resultAsFloat = malloc(n);
        float min = (float)kNyxMinPixelComponentValue, max = (float)kNyxMaxPixelComponentValue;
        
        /// Red components
        vDSP_vfltu8(data + 1, 4, dataAsFloat, 1, pixelsCount);
        vDSP_f3x3(dataAsFloat, height, width, __f_sharpen_kernel_3x3, resultAsFloat);
        vDSP_vclip(resultAsFloat, 1, &min, &max, resultAsFloat, 1, pixelsCount);
        vDSP_vfixu8(resultAsFloat, 1, data + 1, 4, pixelsCount);
        
        /// Green components
        vDSP_vfltu8(data + 2, 4, dataAsFloat, 1, pixelsCount);
        vDSP_f3x3(dataAsFloat, height, width, __f_sharpen_kernel_3x3, resultAsFloat);
        vDSP_vclip(resultAsFloat, 1, &min, &max, resultAsFloat, 1, pixelsCount);
        vDSP_vfixu8(resultAsFloat, 1, data + 2, 4, pixelsCount);
        
        /// Blue components
        vDSP_vfltu8(data + 3, 4, dataAsFloat, 1, pixelsCount);
        vDSP_f3x3(dataAsFloat, height, width, __f_sharpen_kernel_3x3, resultAsFloat);
        vDSP_vclip(resultAsFloat, 1, &min, &max, resultAsFloat, 1, pixelsCount);
        vDSP_vfixu8(resultAsFloat, 1, data + 3, 4, pixelsCount);
        
        free(dataAsFloat);
        free(resultAsFloat);
    }
    
    CGImageRef sharpenedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* sharpened = [UIImage imageWithCGImage:sharpenedImageRef];
    
    /// Cleanup
    CGImageRelease(sharpenedImageRef);
    CGContextRelease(bmContext);
    
    return sharpened;
}

#pragma mark playSound
void onAudioPlaySoundCompletion_L(SystemSoundID ssID, void* clientData) {
    AudioServicesDisposeSystemSoundID(ssID);
}

SystemSoundID AudioPlaySoundL(NSString* soundName) {
    SystemSoundID pmph = -1;
    
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"QQBizAgent.bundle/sound/"];
    NSString *path = [main_images_dir_path stringByAppendingPathComponent:soundName];
    //NSString* path = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
    if (path != nil) {
        CFURLRef baseURL = ( CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:path]);
        AudioServicesCreateSystemSoundID(baseURL, &pmph);
        AudioServicesPlaySystemSound(pmph);
        AudioServicesAddSystemSoundCompletion(pmph, NULL, NULL, onAudioPlaySoundCompletion_L, NULL);
        CFBridgingRelease(baseURL);
    }
    
    return pmph;
}

void AudioStopPlayL(SystemSoundID soundID) {
    if (soundID == 0) {
        return;
    }
    
    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
}


@implementation PTCodeReaderUtil

+  (UIImage*) sharpenImage:(UIImage *)srcImg sharpness:(CGFloat)sharpness
{
    //    if (SYSTEM_VERSION >= 6.0)
    //    {
    //        return [TCUtil sharpenImage_v60:srcImg sharpness:sharpness];
    //    }
    
    if (SYSTEM_VERSION >= 5.0)
    {
        return sharpenWithBias(srcImg,0);
    }
    
    return srcImg;
}


+ (UIImage *)scaleToSizeByAspectMax:(UIImage *)image targetSize:(CGFloat)targetSize
{
    CGFloat scaleWidth = image.size.width;
    CGFloat scaleHeight = image.size.height;
    
    if (image.size.width > targetSize || image.size.height > targetSize) {
        CGFloat scaleFactor = 0.0;
        CGFloat widthFactor = targetSize / image.size.width;
        CGFloat heightFactor = targetSize / image.size.height;
        
        //取小的比率值
        scaleFactor = (widthFactor < heightFactor) ? widthFactor : heightFactor;
        
        //四舍五入取整
        scaleWidth  = round(scaleFactor * image.size.width);
        scaleHeight = round(scaleFactor * image.size.height);
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaleWidth, scaleHeight));
    [image drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    UIImage* outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outImage;
}

+ (BOOL) torchAvailable
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash])
        {
            return YES;
        }
    }
    
    return NO;
}

+(BOOL) isConnectionAvailable
{
    // 创建零地址，0.0.0.0地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    
    SCNetworkReachabilityFlags flags;
    // Get connect flags
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    // 如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // if target host is not reachable
        return NO;
    }
    
    return YES;
    
    // 根据获得的连接标志进行判断
    //    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    //    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    //
    //    return (isReachable && !needsConnection) ? YES : NO;
    
}


+(UIImage*) imagesNamedFromCustomBundle:(NSString *)name
{
    return [PTCodeReaderUtil imageNamed:name inDirectory:@"images"];
}

+ (UIImage *)imageNamed:(NSString *)name inDirectory:(NSString *)directory
{
    if (nil == name
        || nil == directory)
    {
        return nil;
    }
    
    NSString *directoryPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"QQBizAgent.bundle/%@/", directory]];
    
    NSString *imagePath = nil;
    //无论是否retina屏幕 我们优先取@2x的图片
    NSRange range = [name rangeOfString:@"."];
    if (NSNotFound != range.location)
    {
        NSMutableString* newStr = [NSMutableString stringWithString:name];
        [newStr insertString:@"@2x" atIndex:range.location];
        imagePath = [directoryPath stringByAppendingPathComponent:newStr];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (nil != image)
        {
            return image;
        }
    }
    
    imagePath = [directoryPath stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:imagePath];
}


@end
