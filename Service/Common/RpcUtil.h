//
//  RpcUtil.h
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RpcUtil : NSObject
+(long long) getCurrentTimeMs;
+(NSDate*) toNSDate:(long long) ms;
+(long long) toTimeMs:(NSDate*) date;

+(NSData *)randomDataWithBytes: (NSUInteger)length;
+(NSData *)encryptDESData:(NSData *)data key:(NSData*) desKey;
+(NSData *)encryptDES:(NSString *)str key:(NSData*) desKey;
+(NSData*) decryptDES:(NSData*) data desKey:(NSData*) desKey;
+(NSData *)encryptRSA:(NSData *)data key:(SecKeyRef)publicKey;
+(NSData*) parseHttpStyleData:(NSData*) decodeData headers:(NSMutableDictionary*) headers;
+(NSString*) md5:(NSString *)str;
//检测换行字符和非ASCII字符, 这些字符在http header里面会导致这个header失效.
//例如user-agent包含换行, 就会导致用户系统默认的user-agent.
+(void) checkUnSafeLetter:(NSString*) str onlyAscii:(BOOL) onlyAscii;

+(NSString *) URLEncodedString:(NSString*) str;
+(NSString *) URLDecodedString:(NSString*) str;

+(NSDate*) gmtToDate:(NSString*) str;
@end
