//
//  PTFoundationDebugListTableViewController.m
//  PTKit
//
//  Created by LeeHu on 8/17/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTFoundationDebugListTableViewController.h"
#import "NSObject+Extents.h"
#import "Sark.h"
#import "Father.h"
#import "Son.h"

@implementation PTFoundationDebugListTableViewController


__weak id reference = nil;
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    id obj1 = [NSArray alloc];
    id obj2 = [NSMutableArray alloc];
    id obj3 = [obj1 init];
    id obj4 = [obj2 init];
    
    NSString *str = [NSString stringWithFormat:@"sunnyxx"];
    reference = str;
    [self Test];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",reference);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@",reference);
}

- (void)Test
{
    // start
    {
        // before new
        Son *son = [Son new];
        son.name = @"sark";
        son.toys = @[@"sunny", @"xx"];
        // after new
    }
    // gone
}

@end
