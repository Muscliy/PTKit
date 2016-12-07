//
//  PTSearchDisplayController.h
//  PTKit
//
//  Created by LeeHu on 9/21/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTBaseViewCotroller.h"

@interface PTSearchDisplayController : PTBaseViewCotroller

@property (nonatomic, strong) UIViewController *searchContentsController;
@property (nonatomic, strong) UIViewController *searchSuggestionController;

- (void)searchText:(NSString *)text;
- (void)searchtextChanged:(NSString *)text;
- (void)showSuggestionController:(NSString *)text;
- (void)showContentsController:(NSString *)text;

@end
