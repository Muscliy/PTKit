//
//  PTSearchNavigatonBar.h
//  PTKit
//
//  Created by LeeHu on 9/21/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTSearchNavigatonBar;

@protocol PTSearchNavigationBarDelegate <NSObject>

@required
- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar textChanged:(NSString *)text;
- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar searchCanceled:(BOOL)canceled;
- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar searchText:(NSString *)text;

@optional
- (void)searchBar:(PTSearchNavigatonBar *)searchNavigationBar beginSearch:(NSString *)text;

@end

@interface PTSearchNavigatonBar : UIView

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSUInteger maxLengthText;
@property (nonatomic, weak) id<PTSearchNavigationBarDelegate> delegate;

@end
