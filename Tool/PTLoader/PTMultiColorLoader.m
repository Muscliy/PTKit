//
//  PTMultiColorLoader.m
//  PTKit
//
//  Created by LeeHu on 12/30/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTMultiColorLoader.h"

#define DEFAULT_COLOR [UIColor orangeColor]
static const NSTimeInterval kAnimationARoundDuration = 1.5;
static const CGFloat kDefaultLineWidth = 2.0;
static NSString *const kStrokeLineAnimationkey = @"kStrokeLineAnimationkey";
static NSString *const kRotationAnimationKey = @"kRotationAnimationKey";
static NSString *const kStrokeColorAnimationKey = @"kStrokeColorAnimationKey";

@interface PTMultiColorLoader ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAAnimationGroup *strokeLineAnimation;
@property (nonatomic, strong) CAAnimation *rotationAnimation;
@property (nonatomic, strong) CAAnimation *strokeColorAnimation;
@property (nonatomic, assign) BOOL animating;

@end

@implementation PTMultiColorLoader

#pragma mark - Life cycle
- (instancetype)init
{
    if ((self = [super init])) {
        [self initialSubLayers];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self initialSubLayers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialSubLayers];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGFloat radius =
        MIN(self.bounds.size.width, self.bounds.size.height) / 2 - self.circleLayer.lineWidth / 2.0;

    CGFloat startAngle = 0;
    CGFloat endAngle = 2 * M_PI;

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    _circleLayer.path = path.CGPath;
    _circleLayer.frame = self.bounds;
}

- (void)initialSubLayers
{
    self.circleLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_circleLayer];
    self.backgroundColor = [UIColor clearColor];
    _circleLayer.fillColor = nil;
    _circleLayer.lineWidth = kDefaultLineWidth;
    _circleLayer.lineCap = kCALineCapRound;
    self.colors = @[ DEFAULT_COLOR ];
	[self p_updateAnimations];
}

#pragma mark -
- (void)setColors:(NSArray<UIColor *> *)colors
{
    if (colors.count > 0) {
        _colors = colors;
    }
    [self p_updateAnimations];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    _circleLayer.lineWidth = lineWidth;
}

#pragma mark - public method
- (void)startAnimation
{
    _animating = YES;
    [_circleLayer addAnimation:_strokeLineAnimation forKey:kStrokeLineAnimationkey];
    [_circleLayer addAnimation:_rotationAnimation forKey:kRotationAnimationKey];
    [_circleLayer addAnimation:_strokeColorAnimation forKey:kStrokeColorAnimationKey];
}
- (void)stopAnimation
{
    _animating = NO;
    [_circleLayer removeAnimationForKey:kStrokeLineAnimationkey];
    [_circleLayer removeAnimationForKey:kStrokeColorAnimationKey];
    [_circleLayer removeAnimationForKey:kRotationAnimationKey];
}

- (void)stopAnimationAfter:(NSTimeInterval)timeInterval
{
    [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:timeInterval];
}

- (BOOL)isAnimating
{
    return _animating;
}

#pragma mark - private method
- (void)p_updateAnimations
{
    CABasicAnimation *headeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headeAnimation.beginTime = kAnimationARoundDuration / 3.0;
    headeAnimation.fromValue = @0;
    headeAnimation.toValue = @1;
    headeAnimation.duration = 2 * kAnimationARoundDuration / 3.0;
    headeAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *tailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation.fromValue = @0;
    tailAnimation.toValue = @1;
    tailAnimation.duration = 2 * kAnimationARoundDuration / 3.0;
    tailAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kAnimationARoundDuration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[headeAnimation,tailAnimation];
    self.strokeLineAnimation = animationGroup;

    CABasicAnimation *rotationAnimation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = kAnimationARoundDuration;
    rotationAnimation.repeatCount = INFINITY;
    self.rotationAnimation = rotationAnimation;

    CAKeyframeAnimation *storkeColorAnimation =
        [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    storkeColorAnimation.values = [self p_prepareColorValues];
    storkeColorAnimation.keyTimes = [self p_prepareKeyTimes];
    storkeColorAnimation.calculationMode = kCAAnimationDiscrete;
    storkeColorAnimation.duration = _colors.count * kAnimationARoundDuration;
    storkeColorAnimation.repeatCount = INFINITY;
	self.strokeColorAnimation = storkeColorAnimation;
}

- (NSArray *)p_prepareColorValues
{
    NSMutableArray *cgColorArray = [[NSMutableArray alloc] init];
    for (UIColor *color in _colors) {
        [cgColorArray addObject:(id)color.CGColor];
    }
    return cgColorArray;
}

- (NSArray<NSNumber *> *)p_prepareKeyTimes
{
    NSMutableArray *keyTimesArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < _colors.count + 1; i++) {
        [keyTimesArray addObject:[NSNumber numberWithFloat:i * 1.0 / _colors.count]];
    }
    return keyTimesArray;
}

@end
