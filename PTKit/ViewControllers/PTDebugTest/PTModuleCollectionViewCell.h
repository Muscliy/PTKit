//
//  PTModuleCollectionViewCell.h
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTNetworkImageView.h"
#import "PTCollectionViewLayoutAttributes.h"
#import "NimbusCollections.h"

@interface PTModuleCollectionViewCellUserData : NSObject

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSString *imageUrl;

@end

@interface PTModuleCollectionViewCell : UICollectionViewCell<NICollectionViewCell>

@property (nonatomic, strong) PTModuleCollectionViewCellUserData *userData;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) PTNetworkImageView *icon;
@property (nonatomic, strong) PTCollectionViewLayoutAttributes *layoutAttributes;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *leftLine;
+ (NICollectionViewCellObject *)createObject:(id)_delegate userData:(id)_userData;

@end
