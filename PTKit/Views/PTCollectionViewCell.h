//
//  PTCollectionViewCell.h
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusCollections.h"

@interface PTCollectionViewCell : UICollectionViewCell<NICollectionViewCell>

+ (NICollectionViewCellObject *)createObject:(id)_delegate userData:(id)_userData;

@end
