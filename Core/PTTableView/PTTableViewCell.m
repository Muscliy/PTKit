//
//  PTTableViewCell.m
//  PTKit
//
//  Created by LeeHu on 8/14/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTTableViewCell.h"

@implementation PTTableViewCell

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    return YES;
}

+ (NICellObject *)createObject:(id)_delegate userData:(id)_userData
{
    NSString *userDataName =
    [NSString stringWithFormat:@"%@UserData", NSStringFromClass([self class])];
    id userInfo = [[NSClassFromString(userDataName) alloc] init];
    
    NICellObject *cellObject =
    [[NICellObject alloc] initWithCellClass:[self class] userInfo:userInfo];
    return cellObject;
}

@end
