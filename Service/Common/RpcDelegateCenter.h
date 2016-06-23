//
//  RpcDelegateCenter.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RpcContext;

@protocol RpcDelegate <NSObject>
@required
-(NSString*) getSesionKey;
-(NSString*) getUid;
-(NSString*) getAcceptLanguage;
-(void) onRpcKickOut:(NSInteger) returnCode;
-(void) onNeedUpgrade:(NSString*) version;

-(NSInteger) getClientType;
-(NSString*) getVersionStr;
-(NSString*) getDeviceModel;
-(NSString*) getDeviceVersion;
-(NSInteger) getScreenWidth;
-(NSInteger) getScreenHeight;
-(NSString*) getDeviceId;
-(void) onSessionChanged:(NSString*) newSession;
-(NSString*) getDeviceToken;
-(NSString*) getDataDir;
-(NSString*) getUserAgent;

-(int) getScreenScale;

// DeviceType.h
-(int) getNetworkType;



@optional
// 主要用于判断图片是否加载过了
-(BOOL) isUrlCached:(NSString*) url;
-(BOOL) onProcessResponse:(RpcContext*) context;
@end

@interface RpcDelegateCenter : NSObject<RpcDelegate>

+ (RpcDelegateCenter *) singleton;

@property(nonatomic, weak) id<RpcDelegate> delegate;

@end
