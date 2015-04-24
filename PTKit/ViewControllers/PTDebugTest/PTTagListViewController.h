//
//  PTTagListViewController.h
//  PTKit
//
//  Created by LeeHu on 15/4/15.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTBaseViewCotroller.h"
#import "PTTagView.h"

@interface PTTagListViewController : PTBaseViewCotroller
@property (nonatomic, strong) PTTagView *tagList;
@property (nonatomic, strong) NSMutableArray *array;
@end
