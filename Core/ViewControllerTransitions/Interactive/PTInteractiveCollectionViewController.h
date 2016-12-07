//
//  PTInteractiveCollectionViewController.h
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTCollectionViewController.h"
#import "PTCollectionViewCell.h"
#import "PTNetworkImageView.h"

@class PTInteractiveCollectionViewCell;
@class PTInteractiveCollectionViewCellUserData;

@interface PTInteractiveCollectionViewController : PTCollectionViewController<UICollectionViewDelegate>

@end

@interface PTInteractiveCollectionViewCellUserData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *overView;

@end

@interface PTInteractiveCollectionViewCell : PTCollectionViewCell

@property (nonatomic, strong) PTNetworkImageView *networkImageView;
@property (nonatomic, strong) PTInteractiveCollectionViewCellUserData *userData;

@end