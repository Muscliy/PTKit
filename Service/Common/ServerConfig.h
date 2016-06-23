//
//  ServerConfig.h
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONSTANTS_TOPIC_CATEGORY @"topic"
#define CONSTANTS_DEFAULT_CATEGORY @"_dc"


@interface ServerConfig : NSObject


/**
 *  获取当前客户端网络的环境
 *
 *  @return dev rc 或者production等等
 */
+ (NSString*) getServerTypeKey;

/**
 *  获取所有网络地址的type对应的key
 *
 *  @return return value description
 */
+ (NSSet*) getAllServerTypeKey;

/**
 *  切换客户端请求的网络环境
 *	此方法只有在DEBUG环境下才能起效
 *
 *  @param key
 */
+ (void) setServerTypeKey:(NSString*) key;


/**
 *  在当前网络环境下添加一种类型地址
 *
 *  @param category 类型
 *  @param urls     地址数组
 *
 *  @return 成功或者失败
 */
+ (BOOL) setUrls:(NSString*) category urls:(NSArray*) urls;

/**
 *  给指定的网络环境中添加一种类型地址
 *
 *  @param category      类型
 *  @param urls          地址数组
 *  @param serverTypeKey 网络环境
 *
 *  @return 成功或者失败
 */
+ (BOOL) setUrls:(NSString*) category urls:(NSArray*) urls serverTypeKey:(NSString*) serverTypeKey;

/**
 *  获取当前网络环境下的一种类型的地址
 *
 *  @param category 地址类型
 *
 *  @return 地址字符串
 */
+ (NSArray*) getUrls:(NSString*) category;

/**
 *  获取当前最前面的host地址
 *
 *  @param category
 *
 *  @return
 */
+ (NSString*) getOneUrl:(NSString*) category;

/**
 *  获取指定网络环境下的一种类型地址
 *
 *  @param category      地址类型
 *  @param serverTypeKey 网络环境
 *
 *  @return 地址字符串
 */
+ (NSArray*) getUrls:(NSString*) category serverTypeKey:(NSString*) serverTypeKey;

/**
 *  get server type all category address
 *
 *  @param serverTypeKey
 *
 *  @return dict
 */
+ (NSDictionary*) getCategoryUrlMap:(NSString*) serverTypeKey;

+ (NSDictionary*) getCategoryUrlMap;
+ (NSDictionary*) getUrlTryCount;

@end
