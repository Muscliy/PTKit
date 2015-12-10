//
//  PTRefreshContentView.h
//  PTKit
//
//  Created by LeeHu on 10/22/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTRefreshContentView : UIView

- (void)refreshControlPullingProgress:(CGFloat)progress;
- (void)refreshControlBeginLoading:(BOOL)animated;
- (void)refreshControlFinishLoading:(BOOL)animated;

@end
