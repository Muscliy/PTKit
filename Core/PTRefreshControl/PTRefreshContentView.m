//
//  PTRefreshContentView.m
//  PTKit
//
//  Created by LeeHu on 10/22/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTRefreshContentView.h"
#import "PTUIMathUtilities.h"

@interface PTRefreshContentView ()

@property (nonatomic, strong) UIView *progressView;

@end

@implementation PTRefreshContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)init
{
    if ((self = [super init])) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
    _progressView.backgroundColor = [UIColor cyanColor];
    [self addSubview:_progressView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _progressView.frame = CGRectMake(0, 0, self.ex_width, self.ex_height);
}

- (void)setProgressViewProgress:(CGFloat)progress
{
   
}


- (void)refreshControlPullingProgress:(CGFloat)progress
{
    [self setProgressViewProgress:progress];
}

- (void)refreshControlBeginLoading:(BOOL)animated
{

}

- (void)refreshControlFinishLoading:(BOOL)animated
{
    
}

@end
