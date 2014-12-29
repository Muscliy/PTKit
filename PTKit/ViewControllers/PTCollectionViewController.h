//
//  PTCollectionViewController.h
//  PTKit
//
//  Created by LeeHu on 14/12/15.
//  Copyright (c) 2014年 LeeHu. All rights reserved.
//

#import "PTBaseViewCotroller.h"
#import "PTCollectionView.h"
#import "NimbusCore.h"
#import "NimbusModels.h"
#import "NimbusCollections.h"
#import "EGORefreshTableHeaderView.h"

@interface PTCollectionViewController
    : PTBaseViewCotroller <UICollectionViewDelegate, NICollectionViewModelDelegate,
                           EGORefreshTableHeaderDelegate, UIScrollViewDelegate> {
    BOOL isEGORefresh;
}

@property (nonatomic, strong) PTCollectionView *collectionView;
@property (nonatomic, strong) NIMutableCollectionViewModel *model;
@property (nonatomic, strong) NICollectionViewModelFooter *footerModel;
@property (nonatomic, strong) EGORefreshTableHeaderView *loadingHead;
@property (nonatomic, assign) BOOL isLoading;

- (UICollectionViewLayout *)flowLayout;
- (void)setCollectionData:(NSArray *)collectionCells;
- (void)addCollectionData:(NSArray *)collectionCells;
- (void)appendCollectionData:(NSArray *)collectionCells;
- (void)addCollectionDataWithSectionedArray:(NSArray *)sectionedArray;
- (BOOL)loadByPage;
- (void)onLoadNextPage;
- (void)onLoadEnd;
- (BOOL)hasLoadingHead;
- (void)egoRefreshServerData;
- (void)doneLoadSeverData;

- (UIView *)getEmptyView;
- (UIView *)getLoadingView;
- (UIView *)getErrorView;
- (UIView *)getGuideViewContain:(UIImage *)icon;
- (UIView *)getGuideViewContain:(UIImage *)icon withTitle:(NSString *)title;
- (UIView *)getGuideViewContain:(UIImage *)icon
                      withTitle:(NSString *)title
                withButtonTitle:(NSString *)buttonTitle
                         action:(SEL)action;

@end
