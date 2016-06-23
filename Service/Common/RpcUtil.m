//
//  RpcUtil.m
//  PTKit
//
//  Created by LeeHu on 6/20/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "RpcUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation RpcUtil

+(long long) getCurrentTimeMs {
	NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
	t *= 1000;
	long long ret = t;
	return ret;
}

+(NSData *)randomDataWithBytes: (NSUInteger)length {
	NSMutableData *mutableData = [NSMutableData dataWithCapacity: length];
	for (NSUInteger i = 0; i < length; i++) {
		NSInteger randomBits = arc4random();
		[mutableData appendBytes: (void *) &randomBits length: 1];
	} return mutableData;
}

+(NSData *)encryptDESData:(NSData *)data key:(NSData*) desKey {
	if(!data) {
		return nil;
	}
	size_t numBytesEncrypted = 0;
	NSUInteger bufferSize = (data.length + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
	void *buffer_encrypt = malloc(bufferSize);
	CCCryptorStatus result = CCCrypt( kCCEncrypt , kCCAlgorithmDES, kCCOptionPKCS7Padding|kCCOptionECBMode,
									 desKey.bytes, kCCKeySizeDES,
									 NULL,
									 data.bytes, data.length,
									 buffer_encrypt, bufferSize,
									 &numBytesEncrypted );
	NSData *encryptData = result == kCCSuccess ? [NSData dataWithBytes:buffer_encrypt length:numBytesEncrypted] : nil;
	free(buffer_encrypt);
	if( result != kCCSuccess || !encryptData)
		{
		NSLog(@"Failed DES encrypt ...");
		return nil;
		}
	
	return encryptData;
}

+(NSData *)encryptDES:(NSString *)str key:(NSData*) desKey {
	if(!str) {
		return nil;
	}
	
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	return [self encryptDESData:data key:desKey];
}

+(NSData *)encryptRSA:(NSData *)strData key:(SecKeyRef)publicKey
{
	if(!strData) {
		return nil;
	}
	
	size_t cipherBufferSize;
	uint8_t *cipherBuffer;
	
	size_t dataSize = strData.length;
	const uint8_t* textData = [strData bytes];
	
	cipherBufferSize = SecKeyGetBlockSize(publicKey);
	// plain text block size must be 11 less than cipher buffer size because of
	// the PKSC1 padding used:
	const size_t blockSizeMinusPadding = cipherBufferSize - 11;
	cipherBuffer = malloc(cipherBufferSize);
	
	NSMutableData* accumulatedEncryptedData = [NSMutableData dataWithCapacity:1024];
	
	for (size_t ii = 0; ii*blockSizeMinusPadding < dataSize; ii++) {
		const uint8_t* dataToEncrypt = (textData+(ii*blockSizeMinusPadding));
		const size_t subsize = (((ii+1)*blockSizeMinusPadding) > dataSize) ? blockSizeMinusPadding-(((ii+1)*blockSizeMinusPadding) - dataSize) : blockSizeMinusPadding;
		
		// Encrypt using the public key.
		SecKeyEncrypt(publicKey,
					  kSecPaddingPKCS1,
					  dataToEncrypt,
					  subsize,
					  cipherBuffer,
					  &cipherBufferSize
					  );
		[accumulatedEncryptedData appendBytes:cipherBuffer length:cipherBufferSize];
	}
	
	free(cipherBuffer);
	
	return accumulatedEncryptedData;
}

+(NSData*) decryptDES:(NSData*) data desKey:(NSData*) desKey {
	if(!data) {
		return nil;
	}
	size_t numBytesEncrypted = 0;
	size_t bufferSize = data.length + kCCBlockSizeDES;
	void *buffer_decrypt = malloc(bufferSize);
	CCCryptorStatus result = CCCrypt( kCCDecrypt , kCCAlgorithmDES, kCCOptionPKCS7Padding|kCCOptionECBMode,
									 desKey.bytes, kCCKeySizeDES,
									 NULL,
									 data.bytes, data.length,
									 buffer_decrypt, bufferSize,
									 &numBytesEncrypted );
	NSData *decryptData = result == kCCSuccess ? [NSData dataWithBytes:buffer_decrypt length:numBytesEncrypted] : nil;
	free(buffer_decrypt);
	if( result != kCCSuccess || !decryptData)
		{
		NSLog(@"Failed DES decrypt ...");
		return nil;
		}
	
	
	return decryptData;
}


+(NSData*) parseHttpStyleData:(NSData*) decodeData headers:(NSMutableDictionary*) headers {
	if(!decodeData) {
		return nil;
	}
	
	BOOL isKey = YES;
	NSMutableString* key = [NSMutableString stringWithString:@""];
	NSMutableString* value = [NSMutableString stringWithString:@""];
	char* bytes = (char*)[decodeData bytes];
	NSUInteger len = [decodeData length];
	NSUInteger i = 0;
	for(; i < len; i++) {
		char c = bytes[i];
		if(c == ':' && isKey) {
			isKey = FALSE;
		} else if(c == '\n') {
			if([key length] < 1) {
				break;
			}
			id oldValue = [headers objectForKey:key];
			if(oldValue) {
				if([oldValue isKindOfClass:[NSArray class]]) {
					NSMutableArray* arr = (NSMutableArray*) oldValue;
					[arr addObject:value];
				} else {
					NSMutableArray* arr = [NSMutableArray arrayWithObject: oldValue];
					[arr addObject:value];
					[headers setObject:arr forKey:key];
				}
			} else {
				[headers setObject:value forKey:key];
			}
			value = [NSMutableString stringWithString:@""];
			key = [NSMutableString stringWithString:@""];
			isKey = TRUE;
		} else {
			if (isKey)
				[key appendFormat:@"%c" , c];
			else
				[value appendFormat:@"%c" , c];
		}
	}
	if(i + 1 < len) {
		NSData* strData =   [decodeData subdataWithRange:NSMakeRange(i+1, len - i -1)];
		return strData;
	}
	return nil;
}

+(NSString*) md5:(NSString *)str {
	if(!str)
		return nil;
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)(strlen(cStr)), result);
	return [[NSString stringWithFormat:
			 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1], result[2], result[3],
			 result[4], result[5], result[6], result[7],
			 result[8], result[9], result[10], result[11],
			 result[12], result[13], result[14], result[15]
			 ] lowercaseString];
}

+(void) checkUnSafeLetter:(NSString*) str onlyAscii:(BOOL) onlyAscii {
	NSUInteger len = str.length;
	for(NSUInteger i = 0; i < len; i++) {
		unichar c = [str characterAtIndex:i];
		if(c == '\r' || c == '\n' || (onlyAscii && (c >= 256 || c < 0))) {
			NSAssert(FALSE, @"bad character");
		}
	}
}

+(NSDate*) toNSDate:(long long) ms {
	NSTimeInterval time = ms / 1000;
	return [NSDate dateWithTimeIntervalSince1970:time];
}

+(long long) toTimeMs:(NSDate*) date {
	NSTimeInterval t = [date timeIntervalSince1970];
	t *= 1000;
	long long ret = t;
	return ret;
}

+(NSString *) URLEncodedString:(NSString*) str
{
	CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																  (__bridge CFStringRef)str,
																  NULL,
																  CFSTR("\n\r!*'\"();:@&=+$,/?%#[]% "),
																  kCFStringEncodingUTF8);
	return CFBridgingRelease(encoded);
}

+(NSString *) URLDecodedString:(NSString*) str {
	CFStringRef decoded = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																				  (__bridge CFStringRef)str,
																				  CFSTR("\n\r!*'\"();:@&=+$,/?%#[]% "),
																				  kCFStringEncodingUTF8);
	return CFBridgingRelease(decoded);
}

+(NSDate*) gmtToDate:(NSString*) str {
	static NSDateFormatter *dateFormatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
		[dateFormatter setTimeZone:timeZone];
		[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
	});
	NSDate* date = [dateFormatter dateFromString:str];
	return date;
}


@end
