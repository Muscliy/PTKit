//
//  PTViewController.h
//  PTKit
//
//  Created by LeeHu on 11/6/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTNavigationBar.h"
#import "PTBaseViewCotroller.h"

@interface PTViewController : PTBaseViewCotroller

@property (nullable, nonatomic, strong) PTNavigationBar *navigationBar;
- (void)addNavigationBar;

@end
