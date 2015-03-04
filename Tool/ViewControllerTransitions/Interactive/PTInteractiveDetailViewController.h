//
//  PTInteractiveDetailViewController.h
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTInteractiveCollectionViewController.h"

@interface PTInteractiveDetailViewController : UIViewController

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) PTInteractiveCollectionViewCellUserData *userData;

@property (nonatomic, strong) UIView *transitionFromView;

@end
