//
//  PTAlertView.h
//  PTKit
//
//  Created by LeeHu on 5/28/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PTAlertViewDismissBlock)();
typedef void (^PTAlertViewCancelBlock)();

@interface PTAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *dismissTitle;

+ (PTAlertView*)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle DismissButtonTitle:(NSString *)dismissButton onDismiss:(PTAlertViewDismissBlock) dismissed onCancel:(PTAlertViewCancelBlock) cancelled;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle DismissButtonTitle:(NSString *)dismissButton;

- (void)showInView:(UIView *)view;

@end
