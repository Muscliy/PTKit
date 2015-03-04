//
//  PTInteractiveCollectionViewController.m
//  PTKit
//
//  Created by LeeHu on 15/3/1.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTInteractiveCollectionViewController.h"
#import "PTNetworkImageView.h"
#import "PTRectMacro.h"
#import "PTInteractiveDetailViewController.h"
#import "PTViewControllerPushAnimatedTransitioning.h"

@interface PTInteractiveCollectionViewController ()<UINavigationControllerDelegate>

@end

@implementation PTInteractiveCollectionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor grayColor];
    NSArray *collectionData = @[
        [self createCellTitle:@"Thing1"
                        image:[UIImage imageNamed:@"thing01.jpg"]
                     overView:@"Drumstick cow beef fatback turkey boudin. Meatball leberkas boudin "
                              @"hamburger pork belly fatback."],
        [self createCellTitle:@"Thing2"
                        image:[UIImage imageNamed:@"thing02.jpg"]
                     overView:@"Shank pastrami sirloin, sausage prosciutto spare ribs kielbasa "
                              @"tri-tip doner."],
        [self createCellTitle:@"Thing3"
                        image:[UIImage imageNamed:@"thing03.jpg"]
                     overView:@"Shank pastrami sirloin, sausage prosciutto spare ribs kielbasa "
                              @"tri-tip doner."],
        [self createCellTitle:@"Thing4"
                        image:[UIImage imageNamed:@"thing04.jpg"]
                     overView:@"Shank pastrami sirloin, sausage prosciutto spare ribs kielbasa "
                              @"tri-tip doner."],
        [self createCellTitle:@"Thing5"
                        image:[UIImage imageNamed:@"thing05.jpg"]
                     overView:@"Shank pastrami sirloin, sausage prosciutto spare ribs kielbasa "
                              @"tri-tip doner."],
    ];
    [self setCollectionData:collectionData];
}

- (UICollectionViewLayout *)flowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.minimumInteritemSpacing = 10.0;
    flowLayout.itemSize = CGSizeMake(150, 150);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return flowLayout;
}

- (NICollectionViewCellObject *)createCellTitle:(NSString *)title
                                          image:(UIImage *)image
                                       overView:(NSString *)overView
{
    NICollectionViewCellObject *cellObject =
        [PTInteractiveCollectionViewCell createObject:self userData:nil];
    PTInteractiveCollectionViewCellUserData *userData =
        (PTInteractiveCollectionViewCellUserData *)cellObject.userInfo;
    userData.title = title;
    userData.image = image;
    userData.overView = overView;
    return cellObject;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 150);
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    PTInteractiveDetailViewController *vc =
        [[PTInteractiveDetailViewController alloc] initWithNibName:nil bundle:nil];
    PTInteractiveCollectionViewCell *cell = (PTInteractiveCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    vc.transitionFromView = cell;
    vc.userData = cell.userData;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // Check if we're transitioning from this view controller to a DSLSecondViewController
    if (fromVC == self && [toVC isKindOfClass:[PTInteractiveDetailViewController class]]) {
        return [[PTViewControllerPushAnimatedTransitioning alloc] init];
    }
    else {
        return nil;
    }
}

@end

@interface PTInteractiveCollectionViewCell ()

@end

@implementation PTInteractiveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor redColor];
        _networkImageView = [[PTNetworkImageView alloc] init];

        [self.contentView addSubview:_networkImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _networkImageView.frame = self.bounds;
}

- (BOOL)shouldUpdateCellWithObject:(NICollectionViewCellObject *)object
{
    [super shouldUpdateCellWithObject:object];
    self.userData = (PTInteractiveCollectionViewCellUserData *)object.userInfo;
    self.networkImageView.image = self.userData.image;
    return YES;
}

+ (NICollectionViewCellObject *)createObject:(id)_delegate userData:(id)_userData
{
    PTInteractiveCollectionViewCellUserData *userData =
        [[PTInteractiveCollectionViewCellUserData alloc] init];
    NICollectionViewCellObject *cellObject =
        [[NICollectionViewCellObject alloc] initWithCellClass:[self class] userInfo:userData];
    return cellObject;
}

@end

@implementation PTInteractiveCollectionViewCellUserData

@end
