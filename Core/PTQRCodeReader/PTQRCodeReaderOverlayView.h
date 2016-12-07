//
//  PTQRCodeReaderOverlayView.h
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTQRCodeReaderOverlayView : UIView
{
    BOOL flag;
    BOOL isStopAnimation;
    CGRect lineRectTop ;
    CGRect lineRectBottom ;
    
    UIView  *bgView;
    UILabel  *analyLabel;
    UIActivityIndicatorView  *activityIndicatorView;
}


@property (nonatomic,assign) BOOL isCameraAvailable;

- (void)stopAnimation;
- (void)beginAnimation;

- (void)addAnalyingView;
- (void)removeAnalyingView;


@end

