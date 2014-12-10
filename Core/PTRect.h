//
//  PTRect.h
//  PTKit
//
//  Created by LeeHu on 14/11/26.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Uses CGRectGetMidX() and CGRectGetMidY() to perform the calculation.
 *
 *  @param rect The rectangle
 *
 *  @return A CGPoint, The center point in rect
 */
CGPoint PTRectGetMid(CGRect rect);

/**
 *  Return a rect constructed with a origin point
 *
 *  @param origin The origin for new rect
 *  @param size   The size of the rect
 *
 *  @return A CGRect
 */
CGRect PTRectMakeWithOrigin(CGPoint origin, CGSize size);


/**
 *  Creates a rectangle of a given size with a centerpoint coincident with the given rect.
 *  Uses add a view to superview's center
 *
 *  @param size the size of new rect
 *  @param rect The rect in which the returned rect is centered.
 *
 *  @return A CGRect
 */
CGRect PTRectMakeWithSizeCenteredInRect(CGSize size, CGRect rect);

/**
 *  Creates the largest rectangle with a centerpoint coincident with the given rect, and with the specified aspect ratio that fits within the given rect.
 *
 *	创一个比例为aspect的rectangle，rectangle的center要在rect的center上
 *
 *  @param aspect The aspect ratio (width/height) for the new rect.
 *  @param rect   The rect in which the returned rect lives.
 *
 *  @return A CGRect.
 */
CGRect PTRectMakeWithAspectCenteredInRect(CGFloat aspect, CGRect rect);

/**
 *	创建一个Point ，这个Point位置是outer的center水平移inner 的一半长度
 *
 *  @param inner
 *  @param outer
 *
 *  @return A point
 */
CGPoint PTRectGetOriginCenteredHorizontally(CGRect inner, CGRect outer);

/**
 *  创建一个rectangle它的最大Y坐标为maxY
 *
 *  @param rect
 *  @param maxY
 *
 *  @return A rect
 */
CGRect PTRectSetMaxY(CGRect rect, CGFloat maxY);

/**
 *  创建一个rectangle 讲一个rect的ponint通过progress移动
 *
 *  @param rect1    source rect
 *  @param rect2    des rect
 *  @param progress
 *
 *  @return
 */
CGRect PTRectInterpolate(CGRect rect1, CGRect rect2, CGFloat progress);

/**
 *  Create rectangle by size the origin point is {0, 0}
 *
 *  @param size
 *
 *  @return A rect
 */
CGRect PTRectMakeWithSize(CGSize size);

/**
 *  A point is rectangle center point
 *
 *  @param r
 *
 *  @return a point
 */
CGPoint PTRectGetMidPoint(CGRect r);

/**
 *  rectangle 左边界中点
 *
 *  @param rect
 *
 *  @return
 */
CGPoint PTRectGetMidMinX(CGRect rect);

/**
 *  rectangle 右边界中点
 *
 *  @param rect
 *
 *  @return
 */
CGPoint PTRectGetMidMaxX(CGRect rect);

/**
 *  rectangle 下边界中点
 *
 *  @param rect
 *
 *  @return
 */
CGPoint PTRectGetMidMaxY(CGRect rect);


/**
 *  rectangle 上边界中点
 *
 *  @param rect rect description
 *
 *  @return
 */
CGPoint PTRectGetMidMinY(CGRect rect);


/**
 *  宽高比
 *
 *  @param size
 *
 *  @return
 */
CGFloat PTSizeGetAspectRatio(CGSize size);

/**
 *  限制constraints 的宽高比
 *
 *  @param aspectRatio
 *  @param constraints
 *
 *  @return
 */
CGSize PTSizeFillWithAspectRatio(CGFloat aspectRatio, CGSize constraints);


CGSize PTSizeFitWithAspectRatio(CGFloat aspectRatio, CGSize constraints);

/**
 *  将size调整一个合理的像素值返回
 *
 *  @param size
 *
 *  @return
 */
CGSize PTSizeIntegral(CGSize size);

/**
 *  将point调整一个合理的值返回
 *
 *  @param point
 *
 *  @return
 */
CGPoint PTPointIntegral(CGPoint point);

/**
 *  将size缩放至Maxsize中
 *
 *  @param size
 *  @param maxSize
 *
 *  @return
 */
CGSize PTSizeThatFits(CGSize size, CGSize maxSize);
