//
//  PTModuleCollectionViewController.m
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTModuleCollectionViewController.h"
#import "PTModuleCollectionViewCell.h"
#import "PTCollectionViewLayout.h"
#import "PTBoxManagerAdapter.h"
#import "PTModuleDecorationView.h"
#import "PTModuleHeaderCollectionCell.h"
#import "PTModuleTitleCollectionViewCell.h"
#import "PTNavigationBar.h"

#define kType10Image0 @"http://ts1.mm.bing.net/th?id=R5z%2bkJqXg4TidPayWUdL48QjJYIY%2fVdw8%2bIxQreiWsqXQ&w=272&h=135&c=7&rs=1&qlt=90&pid=1.9"

#define kType10Image1 @"http://ts1.mm.bing.net/th?id=R78ibUGDlV%2byl3ftrVC%2bjRQXK7s2DGiZvnUWyTkgGko9g&w=272&h=135&c=7&rs=1&qlt=90&pid=1.9"

#define kType10Image2 @"http://ts1.mm.bing.net/th?id=RT2AltaZyhcqTxEynHsS9VAJE%2fFrMlqk90tDJlGNpSF3w&w=272&h=135&c=7&rs=1&qlt=90&pid=1.9"

#define kType12Image0 @"http://ts1.mm.bing.net/th?id=RZd6KSJ2TtbbdqdCbD7OhmgFnFLG9hq%2fQ0qUHob%2bKHcmA&w=272&h=272&c=7&rs=1&qlt=90&pid=1.9"

#define kType12Image1 @"http://ts1.mm.bing.net/th?id=RkgIGB%2fmAlC7FbWJ%2fTCKF3AciMT%2fFm9C%2b1h86oyyGsI9g&w=272&h=135&c=7&rs=1&qlt=90&pid=1.9"

#define kType12Image2 @"http://ts1.mm.bing.net/th?&id=HN.608029548307483050&w=300&h=300&c=0&pid=1.9&rs=0&p=0"

#define kType12Image3 @"http://ts1.mm.bing.net/th?&id=HN.608029548307483050&w=300&h=300&c=0&pid=1.9&rs=0&p=0"

@interface PTModuleCollectionViewController ()

@property (nonatomic, strong) PTBoxManagerAdapter *layoutAdapter;


@end

@implementation PTModuleCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor blueColor];
    
    NSArray *collectionContents = @[
                                    @"TYPE10",
                                    [self createItemWithTitles:nil withImage:kType10Image0 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image1 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image2 withClass:[PTModuleCollectionViewCell class]],
                                    @"TYPE8",
                                    [self createItemWithTitles:nil withImage:nil withClass:[PTModuleCollectionViewCell class]],
                                    @"TYPE13",
                                    [self createHeaderItemTitles:@[@"title",@"subtitle"] ],
                                    @"TYPE13",
                                    [self createHeaderItemTitles:@[@"title"] ],
                                    @"TYPE14",
                                    [self createItemWithTitles:nil withImage:kType10Image0 withClass:[PTModuleTitleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image1 withClass:[PTModuleTitleCollectionViewCell class]],
                                    [self createItemWithTitles:@[@"TITLE"] withImage:nil withClass:[PTModuleTitleCollectionViewCell class]],
                                    [self createItemWithTitles:@[@"TITLE"] withImage:nil withClass:[PTModuleTitleCollectionViewCell class]],
                                    [self createItemWithTitles:@[@"TITLE"] withImage:nil withClass:[PTModuleTitleCollectionViewCell class]],
                                    [self createItemWithTitles:@[@"TITLE"] withImage:nil withClass:[PTModuleTitleCollectionViewCell class]],
                                    [self createItemWithTitles:@[@"TITLE"] withImage:nil withClass:[PTModuleTitleCollectionViewCell class]],
                                    [self createItemWithTitles:@[@"TITLE"] withImage:nil withClass:[PTModuleTitleCollectionViewCell class]],
                                    @"TYPE12",
                                    [self createItemWithTitles:nil withImage:kType10Image0 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image0 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image2 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image2 withClass:[PTModuleCollectionViewCell class]],
                                    @"TYPE15",
                                    [self createItemWithTitles:nil withImage:kType10Image2 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image0 withClass:[PTModuleCollectionViewCell class]],
                                    @"TYPE11",
                                    [self createItemWithTitles:nil withImage:kType10Image2 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image0 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image2 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image0 withClass:[PTModuleCollectionViewCell class]],
                                    [self createItemWithTitles:nil withImage:kType10Image2 withClass:[PTModuleCollectionViewCell class]],
                                    ];
    _layoutAdapter.types = @[@"TYPE10",@"TYPE8",@"TYPE13",@"TYPE13",@"TYPE14",@"TYPE12",@"TYPE15",@"TYPE11"];
    [self setCollectionData:collectionContents];
    
}

- (UICollectionViewLayout *)flowLayout
{
    PTCollectionViewLayout *layout = [[PTCollectionViewLayout alloc] init];
    _layoutAdapter = [[PTBoxManagerAdapter alloc] init];
    [layout registerClass:[PTModuleDecorationView class]
  forDecorationViewOfKind:PTCollectionViewLayoutKindBoxGroupBg];
    layout.delegate = _layoutAdapter;
    return layout;
}


- (NICollectionViewCellObject *)createItemWithTitles:(NSArray *)titles withImage:(NSString *)imageUrl withClass:(Class)cls
{
    
    NICollectionViewCellObject *cellObject = [cls createObject:nil userData:nil];
    PTModuleCollectionViewCellUserData *userData = (PTModuleCollectionViewCellUserData *)cellObject.userInfo;
    userData.titles = titles;
    userData.imageUrl = imageUrl;
    return cellObject;
}

- (NICollectionViewCellObject *)createHeaderItemTitles:(NSArray *)titles
{
    NICollectionViewCellObject *cellObject = [PTModuleHeaderCollectionCell createObject:nil userData:nil];
    PTModuleCollectionViewCellUserData *userData = (PTModuleCollectionViewCellUserData *)cellObject.userInfo;
    userData.titles = titles;
    return cellObject;
}

@end
