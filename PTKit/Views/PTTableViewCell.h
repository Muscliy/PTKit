//
//  PTTableViewCell.h
//  PTKit
//
//  Created by LeeHu on 8/14/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusCore.h"
#import "NimbusModels.h"

@interface PTTableViewCell : UITableViewCell<NICell>

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData;

@end
