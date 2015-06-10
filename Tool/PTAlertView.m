//
//  PTAlertView.m
//  PTKit
//
//  Created by LeeHu on 5/28/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTAlertView.h"
#import "UIColor+Extents.h"

@interface PTAlertView()

@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, copy) PTAlertViewDismissBlock dismissBlock;
@property (nonatomic, copy) PTAlertViewCancelBlock cancelBlock;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;
@end

@implementation PTAlertView

+ (PTAlertView *)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle DismissButtonTitle:(NSString *)dismissButtonTitle onDismiss:(PTAlertViewDismissBlock)dismissed onCancel:(PTAlertViewCancelBlock)cancelled
{
    PTAlertView *alertView = [[PTAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle DismissButtonTitle:dismissButtonTitle];
    alertView.dismissBlock = dismissed;
    alertView.cancelBlock = cancelled;
    return alertView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle DismissButtonTitle:(NSString *)dismissButton
{
    if ((self = [super init])) {
        
        self.title = title;
        self.message = message;
        self.cancelTitle = cancelButtonTitle;
        self.dismissTitle = dismissButton;
        [self setUI];
    }
    
    return self;
}

- (void)setUI
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    _blockView.backgroundColor = [UIColor ex_colorWithHexString:@"#F7F7F7"];
    _blockView.layer.masksToBounds = YES;
    _blockView.layer.cornerRadius = 8.0;
    _blockView.clipsToBounds = YES;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    _titleLabel.text = self.title;
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
    _messageLabel.text = self.message;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    _cancelButton.backgroundColor = [UIColor ex_colorWithHexString:@"#F7F7F7"];
    [_cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor ex_colorWithHexString:@"#007aff"] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [_cancelButton addTarget:self action:@selector(cancelButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
 
    _dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    _dismissButton.backgroundColor = [UIColor ex_colorWithHexString:@"#F7F7F7"];
    [_dismissButton setTitle:self.dismissTitle forState:UIControlStateNormal];
    [_dismissButton setTitleColor:[UIColor ex_colorWithHexString:@"#007aff"] forState:UIControlStateNormal];
    _dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [_dismissButton addTarget:self action:@selector(dismissButtonOnClick) forControlEvents:UIControlEventTouchUpInside];

    _horizontalLine = [[UIView alloc] init];
    _horizontalLine.backgroundColor = [UIColor ex_colorWithHexString:@"#8E8E93"];
    
    _verticalLine = [[UIView alloc] init];
    _verticalLine.backgroundColor = [UIColor ex_colorWithHexString:@"#8E8E93"];
    
    [self addSubview:_blockView];
    [_blockView addSubview:_titleLabel];
    [_blockView addSubview:_messageLabel];
    [_blockView addSubview:_cancelButton];
    [_blockView addSubview:_dismissButton];
    [_blockView addSubview:_horizontalLine];
    [_blockView addSubview:_verticalLine];
}

- (void)layoutSubviews
{
    _blockView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 60, 100);
    
    _titleLabel.frame = CGRectMake(10, 15, CGRectGetWidth(_blockView.frame) - 20, 20);
    
    _messageLabel.frame = CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 15, CGRectGetWidth(_blockView.frame) - 40, 20);
    [_messageLabel sizeToFit];
    
    CGRect rect = _messageLabel.frame;
    rect.size.width = _titleLabel.frame.size.width - 20;
    _messageLabel.frame = rect;
    
    rect = _blockView.frame;
    rect.size.height = MAX(150, CGRectGetMaxY(_messageLabel.frame) + 60);
    _blockView.frame = rect;
    _blockView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);

    _cancelButton.frame = CGRectMake(0, CGRectGetHeight(_blockView.bounds) - 44, CGRectGetWidth(_blockView.frame) / 2, 44);
    _dismissButton.frame = CGRectMake(CGRectGetWidth(_blockView.frame) / 2, CGRectGetMinY(_cancelButton.frame), CGRectGetWidth(_blockView.frame) / 2, 44);
    
    _horizontalLine.frame = CGRectMake(0, CGRectGetMinY(_cancelButton.frame), CGRectGetWidth(_blockView.frame), 0.5);
    _verticalLine.frame = CGRectMake(CGRectGetMaxX(_cancelButton.frame), CGRectGetMinY(_cancelButton.frame), 0.5,CGRectGetHeight(_cancelButton.frame));
}

- (void)showInView:(UIView *)view
{
    self.frame = view.bounds;
    [self layoutSubviews];
    [view addSubview:self];
    [self show];
}

- (void)show
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]
                            ];
    popAnimation.keyTimes = @[ @0.0f, @0.5f, @0.75f, @1.0f ];
    popAnimation.timingFunctions = @[
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                     ];
    popAnimation.delegate = nil;
    [_blockView.layer addAnimation:popAnimation forKey:nil];
}


- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)dismissButtonOnClick
{
    self.dismissBlock();
    [self dismiss];
}

- (void)cancelButtonOnClick
{
    self.cancelBlock();
    [self dismiss];
}

@end
