//
//  PTHybirdPlugin.h
//  PTKit
//
//  Created by LeeHu on 6/24/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "CDVPlugin.h"

@interface PTHybirdPlugin : CDVPlugin
PTSingletonInterface;

- (void)startPage:(NSString*)pageName fromViewController:(UIViewController*)fromViewController;

@end
