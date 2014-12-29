//
//  PTNetworkImageView.h
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTNetworkImageView : UIImageView

- (void)setNetworkImage:(id)data;
- (void)setNetworkImage:(id)data placeholderImage:(NSString *)defaultIcon;

@end
