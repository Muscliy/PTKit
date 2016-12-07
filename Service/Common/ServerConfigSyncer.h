//
//  ServerConfigSyncer.h
//  PTKit
//
//  Created by LeeHu on 6/22/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConfigSyncer : NSObject

+(ServerConfigSyncer*) singleton;
-(void) start;
-(void) sync;
-(void) loadServerInfo;

@end
