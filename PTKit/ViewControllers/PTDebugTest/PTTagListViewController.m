//
//  PTTagListViewController.m
//  PTKit
//
//  Created by LeeHu on 15/4/15.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTTagListViewController.h"
#import "PTTagView.h"

@interface PTTagListViewController ()<PTTagViewDelegate>

@end

@implementation PTTagListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tagList = [[PTTagView alloc]
        initWithFrame:CGRectMake(20.0f, 70.0f, self.view.bounds.size.width - 40.0f, 50.0f)];
    [_tagList setAutomaticResize:YES];
    _array = [[NSMutableArray alloc] initWithObjects:@"Foo", @"Tag Label 1", @"Tag Label 2",
                                                     @"Tag Label 3", @"Tag Label 4",
                                                     @"Long long long long long long Tag", nil];
    [_tagList setTags:_array];
    [_tagList setTagDelegate:self];

    // Customisation
    [_tagList setCornerRadius:4.0f];
    [_tagList setBorderColor:[UIColor lightGrayColor]];
    [_tagList setBorderWidth:1.0f];

    [self.view addSubview:_tagList];
}

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:[NSString stringWithFormat:@"You tapped tag %@ at index %ld", tagName,(long)tagIndex]
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
