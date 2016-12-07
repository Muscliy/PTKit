//
//  NSString+Tracking.m
//  xmLife
//
//  Created by weihuazhang on 14-9-26.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "NSString+Tracking.h"
#import "NSObject+Tracking.h"

@implementation NSString (Tracking)

+ (void)load
{
    if (!PTOS_IOS7) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self
                addMissingMethod:@selector(boundingRectWithSize:options:attributes:context:)
                      withMethod:@selector(trackBoundingRectWithSize:options:attributes:context:)];
            [self addMissingMethod:@selector(drawWithRect:options:attributes:context:)
                        withMethod:@selector(trackDrawWithRect:options:attributes:context:)];

            [self addMissingMethod:@selector(sizeWithAttributes:)
                        withMethod:@selector(trackSizeWithAttributes:)];
            [self addMissingMethod:@selector(drawAtPoint:withAttributes:)
                        withMethod:@selector(trackDrawAtPoint:withAttributes:)];

            //此方法在ios6系统有，但还是要替换
            [self swizzleMethod:@selector(drawInRect:withAttributes:)
                     withMethod:@selector(trackDrawInRect:withAttributes:)];
        });
    }
}

- (NSAttributedString *)stringWithAttributes:(NSDictionary *)attrs
{
    return [[NSAttributedString alloc] initWithString:self attributes:attrs];
}

- (void)trackDrawWithRect:(CGRect)rect
                  options:(NSStringDrawingOptions)options
               attributes:(NSDictionary *)attributes
                  context:(NSStringDrawingContext *)context
{
    return
        [[self stringWithAttributes:attributes] drawWithRect:rect options:options context:context];
}

- (CGRect)trackBoundingRectWithSize:(CGSize)size
                            options:(NSStringDrawingOptions)options
                         attributes:(NSDictionary *)attributes
                            context:(NSStringDrawingContext *)context
{
    return [[self stringWithAttributes:attributes] boundingRectWithSize:size
                                                                options:options
                                                                context:context];
}

- (CGSize)trackSizeWithAttributes:(NSDictionary *)attrs
{
    return [[self stringWithAttributes:attrs] size];
}

- (void)trackDrawAtPoint:(CGPoint)point withAttributes:(NSDictionary *)attrs
{
    [[self stringWithAttributes:attrs] drawAtPoint:point];
}

- (void)trackDrawInRect:(CGRect)rect withAttributes:(NSDictionary *)attrs
{
    [[self stringWithAttributes:attrs] drawInRect:rect];
}

@end
