//
//  PTRect.m
//  PTKit
//
//  Created by LeeHu on 14/11/26.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTRect.h"

#import "PTUIMathUtilities.h"

CGPoint PTRectGetMid(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect PTRectMakeWithOrigin(CGPoint origin, CGSize size)
{
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

CGRect PTRectMakeWithSizeCenteredInRect(CGSize size, CGRect rect)
{
    CGPoint centerPoint = PTRectGetMid(rect);
    CGPoint origin = CGPointMake(PTRoundPixelValue(centerPoint.x - (size.width / 2.0)),
                                 PTRoundPixelValue(centerPoint.y - (size.height / 2.0)));
    CGRect centeredRect = PTRectMakeWithOrigin(origin, size);
    return centeredRect;
}

CGRect PTRectMakeWithAspectCenteredInRect(CGFloat aspect, CGRect rect)
{
    const CGFloat width = CGRectGetWidth(rect);
    const CGFloat height = CGRectGetHeight(rect);
    const CGFloat sourceAspect = width / height;

    const CGSize size = (sourceAspect > aspect) ? CGSizeMake(aspect * height, height)
                                                : CGSizeMake(width, width / aspect);
    return PTRectMakeWithSizeCenteredInRect(size, rect);
}

CGPoint PTRectGetOriginCenteredHorizontally(CGRect inner, CGRect outer)
{
    CGPoint centerPoint = PTRectGetMid(outer);
    CGPoint origin =
        CGPointMake(PTRoundPixelValue(centerPoint.x - (inner.size.width / 2.0)), inner.origin.y);
    return origin;
}

CGRect PTRectSetMaxY(CGRect rect, CGFloat maxY)
{
    CGRect adjustedRect = rect;
    adjustedRect.origin.y = maxY - CGRectGetHeight(rect);
    return adjustedRect;
}

CGRect PTRectInterpolate(CGRect rect1, CGRect rect2, CGFloat progress)
{
    CGRect r;
    r.origin.x = rect1.origin.x + (rect2.origin.x - rect1.origin.x) * progress;
    r.origin.y = rect1.origin.y + (rect2.origin.y - rect1.origin.y) * progress;
    r.size.width = rect1.size.width + (rect2.size.width - rect1.size.width) * progress;
    r.size.height = rect1.size.height + (rect2.size.height - rect1.size.height) * progress;
    return r;
}

CGRect PTRectMakeWithSize(CGSize size)
{
    return PTRectMakeWithOrigin(CGPointZero, size);
}

CGPoint PTRectGetMidPoint(CGRect r)
{
    return CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
}

CGPoint PTRectGetMidMinX(CGRect rect)
{
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
}

CGPoint PTRectGetMidMaxX(CGRect rect)
{
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
}

CGPoint PTRectGetMidMaxY(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
}

CGPoint PTRectGetMidMinY(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
}

CGFloat PTSizeGetAspectRatio(CGSize size)
{
    return size.width / size.height;
}

CGSize PTSizeFillWithAspectRatio(CGFloat aspectRatio, CGSize constraints)
{
    CGFloat constraintAspectRatio = PTSizeGetAspectRatio(constraints);
    if (aspectRatio > constraintAspectRatio) {
        return CGSizeMake(constraints.height * aspectRatio, constraints.height);
    } else {
        return CGSizeMake(constraints.width, floorf(constraints.width / aspectRatio));
    }
}

CGSize PTSizeFitWithAspectRatio(CGFloat aspectRatio, CGSize constraints)
{
    CGFloat constraintAspectRatio = PTSizeGetAspectRatio(constraints);
    if (aspectRatio > constraintAspectRatio) {
        return CGSizeMake(constraints.width, constraints.width / aspectRatio);
    } else {
        return CGSizeMake(constraints.height * aspectRatio, constraints.height);
    }
}

CGSize PTSizeIntegral(CGSize size)
{
    return CGSizeMake(PTRoundPixelValue(size.width), PTRoundPixelValue(size.height));
}

CGPoint PTPointIntegral(CGPoint point)
{
    return CGPointMake(PTRoundPixelValue(point.x), PTRoundPixelValue(point.y));
}

CGSize PTSizeThatFits(CGSize size, CGSize maxSize)
{
    if (size.height > maxSize.height) {
        size = CGSizeMake(PTRoundPixelValue(size.width * maxSize.height / size.height),
                          maxSize.height);
    }
    if (size.width > maxSize.width) {
        size =
            CGSizeMake(maxSize.width, PTRoundPixelValue(size.height * maxSize.width / size.width));
    }
    return size;
}
