//
//  ServerConfig.m
//  PTKit
//
//  Created by LeeHu on 5/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "ServerConfig.h"

#define CONSTANTS_PRODUCT_SERVER_KEY @"production"
#define CONSTANTS_TEST_SERVER_KEY @"test"
#define CONSTANTS_DEV_SERVER_KEY @"dev"

static NSMutableDictionary *gServerUrlMap = nil;
static NSMutableDictionary *gUrlTryCount = nil;
static NSMutableDictionary *gSpecialMap = nil;
static NSString *gServerTypeKey = nil;

@implementation ServerConfig

+ (void)initialize
{
    if (!gServerUrlMap) {
        gServerUrlMap = [@{} mutableCopy];
    }
    if (!gUrlTryCount) {
        gUrlTryCount = [@{} mutableCopy];
    }
    if (!gSpecialMap) {
        gSpecialMap = [@{} mutableCopy];
    }

    [ServerConfig loadDefaultConfig];
}

+ (void)loadDefaultConfig
{
    gServerTypeKey = [CONSTANTS_PRODUCT_SERVER_KEY copy];

#if defined(DEBUG)

    [ServerConfig setUrls:CONSTANTS_TOPIC_CATEGORY
                     urls:@[ @"http://www.raywenderlich.com/" ]
            serverTypeKey:@"dev"];

    // TEST    //RC
    [ServerConfig setUrls:CONSTANTS_TOPIC_CATEGORY
                     urls:@[ @"http://www.raywenderlich.com/" ]
            serverTypeKey:@"test"];

    // PRODUCT
    [ServerConfig setUrls:CONSTANTS_TOPIC_CATEGORY
                     urls:@[ @"http://www.raywenderlich.com/" ]
            serverTypeKey:@"product"];

#else

    // PRODUCT
    [ServerConfig setUrls:CONSTANTS_TOPIC_CATEGORY
                     urls:@[ @"http://www.raywenderlich.com/" ]
            serverTypeKey:@"product"];

#endif
}

+ (BOOL)setUrls:(NSString *)category urls:(NSArray *)urls
{
    return [ServerConfig setUrls:category urls:urls serverTypeKey:gServerTypeKey];
}

+ (BOOL)setUrls:(NSString *)category urls:(NSArray *)urls serverTypeKey:(NSString *)serverTypeKey
{

    if (urls.count < 1) {
        return FALSE;
    }

    NSMutableArray *newUrls = [@[] mutableCopy];
    [urls
        enumerateObjectsUsingBlock:^(NSString *_Nonnull url, NSUInteger idx, BOOL *_Nonnull stop) {
          if (!(!url || (NSNull *)url == [NSNull null])) {
              NSAssert([url isKindOfClass:[NSString class]], @"obj is not a NSString object");
              if (![url hasSuffix:@"/"] && [url rangeOfString:@"?"].length == NSNotFound) {
                  [newUrls addObject:[NSString stringWithFormat:@"%@/", url]];
              } else {
                  [newUrls addObject:url];
              }
          }
        }];

    if (newUrls.count < 1) {
        return FALSE;
    }

    NSMutableDictionary *categoryUrlMap = [gServerUrlMap valueForKey:serverTypeKey];
    if (!categoryUrlMap) {
        categoryUrlMap = [@{} mutableCopy];
        [gServerUrlMap setValue:categoryUrlMap forKey:serverTypeKey];
    }

    [categoryUrlMap setValue:newUrls forKey:category];
    [gUrlTryCount setValue:@(0) forKey:category];
    return TRUE;
}

+ (void)setServerTypeKey:(NSString *)key;
{
    NSAssert(key, @"切换环境的变量不能为空");
    gServerTypeKey = key;
}

+ (NSString *)getServerTypeKey
{
    return gServerTypeKey;
}

+ (NSSet *)getAllServerTypeKey
{
    return [NSSet setWithArray:[gServerUrlMap allKeys]];
}

+ (NSString *)getOneUrl:(NSString *)category
{
    return [[ServerConfig getUrls:category] firstObject];
}

+ (NSArray *)getUrls:(NSString *)category
{
    return [ServerConfig getUrls:category serverTypeKey:gServerTypeKey];
}

+ (NSArray *)getUrls:(NSString *)category serverTypeKey:(NSString *)serverTypeKey
{
    if (!category) {
        category = CONSTANTS_DEFAULT_CATEGORY;
    }
    NSMutableDictionary *categoryUrlMap = [gServerUrlMap valueForKey:serverTypeKey];
    if (!categoryUrlMap) {
        return nil;
    }

    NSArray *urlArr = [categoryUrlMap valueForKey:category];
    if (urlArr.count < 1 && ![category isEqualToString:CONSTANTS_DEFAULT_CATEGORY]) {
        category = CONSTANTS_DEFAULT_CATEGORY;
        urlArr = [categoryUrlMap valueForKey:category];
    }
    return urlArr;
}

+ (NSDictionary *)getCategoryUrlMap:(NSString *)serverTypeKey
{
    return [gServerUrlMap valueForKey:serverTypeKey];
}

+ (NSDictionary *)getCategoryUrlMap
{
    return [gServerUrlMap valueForKey:gServerTypeKey];
}

+ (NSDictionary *)getUrlTryCount
{
    return gUrlTryCount;
}


@end
