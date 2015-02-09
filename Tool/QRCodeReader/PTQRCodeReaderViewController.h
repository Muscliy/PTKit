//
//  PTQRCodeReaderViewController.h
//  PTKit
//
//  Created by LeeHu on 15/2/7.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTQRCodeReaderViewControllerDelegate <NSObject>

- (void)QRCodeReaderView:(UIViewController *)vc relsutCode:(NSString *)code;

@end

@interface PTQRCodeReaderViewController : UIViewController

@property (nonatomic, weak)id<PTQRCodeReaderViewControllerDelegate> delegate;

- (void)restartScan;

@end
