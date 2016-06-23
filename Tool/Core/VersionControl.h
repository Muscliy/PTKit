//
//  VersionControl.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionControl : NSObject

+ (NSString *)appBuildVersion;
+ (NSInteger)appVersionInt;

@end
