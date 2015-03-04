//
//  PTCollectionViewCell.m
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTCollectionViewCell.h"

@implementation PTCollectionViewCell

+ (NICollectionViewCellObject *)createObject:(id)_delegate userData:(id)_userData
{
    NSString *userDataName =
    [NSString stringWithFormat:@"%@UserData", NSStringFromClass([self class])];
    id userInfo = [[NSClassFromString(userDataName) alloc] init];
    
    NICollectionViewCellObject *cellObject =
    [[NICollectionViewCellObject alloc] initWithCellClass:[self class] userInfo:userInfo];
    return cellObject;
}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    return YES;
}

@end
