//
//  PTButton.m
//  PTKit
//
//  Created by LeeHu on 12/17/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTButton.h"
#import "PTUIMathUtilities.h"

@interface PTButton ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableDictionary *titles;
@property (nonatomic, strong) NSMutableDictionary *titleColors;
@property (nonatomic, strong) NSMutableDictionary *titleShadowColors;
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSMutableDictionary *backgroundImages;

@end

@implementation PTButton {
	BOOL autoSizeToFit;
}

- (void)dealloc
{
	[self.titleLabel removeObserver:self forKeyPath:@"font"];
}

- (instancetype)init
{
	if ((self = [super init])) {
		[self initDatas];
		[self initSubviews];
	}
	return self;
}

- (void)initDatas
{
	self.titles = [NSMutableDictionary dictionary];
	self.titleColors = [NSMutableDictionary dictionary];
	self.titleShadowColors = [NSMutableDictionary dictionary];
	self.images = [NSMutableDictionary dictionary];
	self.backgroundImages = [NSMutableDictionary dictionary];
	self.distanceTitleBetweenImage = 5;
	self.imagePosition = PTButtonImagePositionLeft;
}

- (void)initSubviews
{
	self.clipsToBounds = YES;
	
	_backgroundView = [UIImageView new];
	_backgroundView.backgroundColor = [UIColor clearColor];
	[self addSubview:_backgroundView];
	
	_contentView = [UIView new];
	_contentView.backgroundColor = [UIColor clearColor];
	_contentView.userInteractionEnabled = NO;
	[self addSubview:_contentView];
	
	_titleLabel = [UILabel new];
	_titleLabel.backgroundColor = [UIColor clearColor];
	[_titleLabel addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
	
	[_contentView addSubview:_titleLabel];
	
	_imageView = [UIImageView new];
	_imageView.backgroundColor = [UIColor clearColor];
	[_contentView addSubview:_imageView];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect frame = CGRectZero;
	if (self.imagePosition == PTButtonImagePositionLeft) {
		frame = self.imageView.frame;
		frame.origin.x = 0;
		self.imageView.frame = frame;
		frame = self.titleLabel.frame;
		frame.origin.x = CGRectGetWidth(self.imageView.bounds) + self.distanceTitleBetweenImage;
		self.titleLabel.frame = frame;
	} else {
		frame = self.titleLabel.frame;
		frame.origin.x = 0;
		self.titleLabel.frame = frame;
		frame = self.imageView.frame;
		frame.origin.x = CGRectGetWidth(self.titleLabel.bounds) + self.distanceTitleBetweenImage;
		self.imageView.frame = frame;
	}
	self.contentView.center =
	CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
	self.titleLabel.center =
	CGPointMake(self.titleLabel.center.x, CGRectGetHeight(self.contentView.frame) / 2.0);
	self.imageView.center =
	CGPointMake(self.imageView.center.x, CGRectGetHeight(self.contentView.frame) / 2.0);
}

- (CGSize)sizeThatFits:(CGSize)size
{
	[super sizeThatFits:size];
	CGSize desSize = CGSizeZero;
	desSize.width = self.imageView.frame.size.width + self.titleLabel.frame.size.width +
	self.distanceTitleBetweenImage;
	
	desSize.width = PTRoundPixIntValue(desSize.width);
	desSize.height = MAX(self.imageView.frame.size.height, self.titleLabel.frame.size.height);
	desSize.height = PTRoundPixIntValue(desSize.height);
	return desSize;
}

- (void)_sizeToFit
{
	[_titleLabel sizeToFit];
	[_imageView sizeToFit];
	CGRect frame = self.contentView.frame;
	frame.size = [self sizeThatFits:CGSizeZero];
	self.contentView.frame = frame;
	if (autoSizeToFit) {
		[self sizeToFit];
	}
	[self layoutIfNeeded];
}

- (void)sizeToFit
{
	[super sizeToFit];
	autoSizeToFit = YES;
	CGRect rect = self.frame;
	CGSize size = [self sizeThatFits:CGSizeZero];
	rect.size.width = MAX(rect.size.width,
						  size.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right);
	rect.size.height = MAX(rect.size.height, size.height + self.contentEdgeInsets.top +
						   self.contentEdgeInsets.bottom);
	self.frame = rect;
}

- (void)setImagePosition:(PTButtonImagePosition)imagePosition
{
	_imagePosition = imagePosition;
	[self updateViews];
}

- (void)setDistanceTitleBetweenImage:(CGFloat)distanceTitleBetweenImage
{
	_distanceTitleBetweenImage = distanceTitleBetweenImage;
	[self updateViews];
}

- (void)updateViews
{
	self.backgroundView.image = [self currentBackgroundImage];
	_titleLabel.text = [self currentTitle];
	_titleLabel.textColor = [self currentTitleColor];
	_titleLabel.shadowColor = [self currentTitleShadowColor];
	_imageView.image = [self currentImage];
	[self _sizeToFit];
}

#pragma mark -
#pragma mark -

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
	if (title)
		_titles[@(state)] = title;
	else
		[_titles removeObjectForKey:@(state)];
	
	[self updateViews];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
	if (color)
		_titleColors[@(state)] = color;
	else
		[_titleColors removeObjectForKey:@(state)];
	
	[self updateViews];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
	if (color)
		_titleShadowColors[@(state)] = color;
	else
		[_titleShadowColors removeObjectForKey:@(state)];
	
	[self updateViews];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
	if (image)
		_images[@(state)] = image;
	else
		[_images removeObjectForKey:@(state)];
	
	if (state == UIControlStateNormal && _images[@(UIControlStateHighlighted)] == nil) {
		[self setImage:[self _tintedImage:image color:[UIColor colorWithWhite:0.0 alpha:0.2]]
			  forState:UIControlStateHighlighted];
	}
	
	[self updateViews];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
	if (image)
		_backgroundImages[@(state)] = image;
	else
		[_backgroundImages removeObjectForKey:@(state)];
	
	[self updateViews];
}

- (NSString *)currentTitle
{
	return [self titleForState:self.state];
}

- (UIColor *)currentTitleColor
{
	return [self titleColorForState:self.state];
}

- (UIColor *)currentTitleShadowColor
{
	return [self titleShadowColorForState:self.state];
}

- (UIImage *)currentImage
{
	return [self imageForState:self.state];
}

- (UIImage *)currentBackgroundImage
{
	return [self backgroundImageForState:self.state];
}

#pragma mark -

- (NSString *)titleForState:(UIControlState)state
{
	return _titles[@(state)] ?: _titles[@(UIControlStateNormal)];
}

- (UIColor *)titleColorForState:(UIControlState)state
{
	return _titleColors[@(state)] ?: _titleColors[@(UIControlStateNormal)];
}

- (UIColor *)titleShadowColorForState:(UIControlState)state
{
	return _titleShadowColors[@(state)] ?: _titleShadowColors[@(UIControlStateNormal)];
}

- (UIImage *)imageForState:(UIControlState)state
{
	return _images[@(state)] ?: _images[@(UIControlStateNormal)];
}

- (UIImage *)backgroundImageForState:(UIControlState)state
{
	return _backgroundImages[@(state)] ?: _backgroundImages[@(UIControlStateNormal)];
}

#pragma mark -

- (UIImage *)_tintedImage:(UIImage *)image color:(UIColor *)color
{
	NSParameterAssert(color);
	UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
	[color setFill];
	CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	UIRectFill(bounds);
	
	//Draw the tinted image in context
	[image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
	
	UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return tintedImage;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self updateViews];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	[self updateViews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[self updateViews];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
	if (object == self.titleLabel) {
		if ([keyPath isEqualToString:@"font"]) {
			[self _sizeToFit];
		}
	}
}

@end
