//
//  Request.m
//  HttpManager
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkRequest.h"
#import "KLNetworkConfigure.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+KLNetworkModule.h"
#import "NSDictionary+KLNetworkModule.h"
#import <CommonCrypto/CommonDigest.h>

@implementation KLNetworkRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestMethod = KLNetworkRequestTypePost;
        _reqeustTimeoutInterval = 10.0;
        _apiVersion = @"1.0";
        _retryCount = 1;
    }
    return self;
}

/** 生成请求实体 @return 请求对象*/
- (NSURLRequest *)generateRequest
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer willChangeValueForKey:@"timeoutInterval"];
    serializer.timeoutInterval = [self reqeustTimeoutInterval];
    [serializer didChangeValueForKey:@"timeoutInterval"];
    serializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSMutableURLRequest *request = [serializer requestWithMethod:[self httpMethod] URLString:[self.baseURL stringByAppendingString:self.requestURL] parameters:[self generateRequestBody] error:NULL];
    // 请求头
    NSMutableDictionary *header = request.allHTTPHeaderFields.mutableCopy;
    if (!header) header = NSMutableDictionary.dictionary;
    // 静态公共请求头
    [header addEntriesFromDictionary:KLNetworkConfigure.shareInstance.generalHeaders];
    // 动态公共请求头
    if (KLNetworkConfigure.shareInstance.generalDynamicHeaders)
        [header addEntriesFromDictionary:KLNetworkConfigure.shareInstance.generalDynamicHeaders()];
    // 特殊请求头
    [header addEntriesFromDictionary:self.requestHeader];
    request.allHTTPHeaderFields = header;
    return request.copy;
}

/** 公共请求参数 @return 请求参数字典 */
- (NSDictionary *)generateRequestBody
{
    // 优先处理加密处理的请求参数
    NSMutableDictionary *temp = NSMutableDictionary.dictionary;
    NSMutableDictionary *mutableDic = self.encryptParams.mutableCopy;
    [mutableDic.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = mutableDic[key];
        NSError *error;
        switch (self.encryptType) {
            case KLEncryptTypeBase64: {
                NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
                if (error == nil) {
                    NSString *valueString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    valueString = [self base64ToString:valueString];
                    [mutableDic setValue:valueString forKey:key];
                } else {
                    NSLog(@"Serialization error.");
                }
            }
                break;
                
            case KLEncryptTypeMD5: {
                NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
                if (error == nil) {
                    NSString *valueString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    valueString = [self md5To32BitString:valueString];
                    [mutableDic setValue:valueString forKey:key];
                } else {
                    NSLog(@"Serialization error.");
                }
            }
                break;
        }
    }];
    [temp addEntriesFromDictionary:mutableDic];
    
    // 静态公共参数
    [temp addEntriesFromDictionary:KLNetworkConfigure.shareInstance.generalParameters];
    // 动态公共参数
    if (KLNetworkConfigure.shareInstance.generalDynamicParameters)
        [temp addEntriesFromDictionary:KLNetworkConfigure.shareInstance.generalDynamicParameters()];
    [temp addEntriesFromDictionary:self.normalParams];
    
    return temp.copy;
}

- (NSString *)httpMethod
{
    KLNetworkRequestType type = [self requestMethod];
    switch (type) {
        case KLNetworkRequestTypePost:
            return @"POST";
        case KLNetworkRequestTypeGet:
            return @"GET";
        case KLNetworkRequestTypePut:
            return @"PUT";
        case KLNetworkRequestTypeDelete:
            return @"DELETE";
        case KLNetworkRequestTypePatch:
            return @"PATCH";
        default:
            break;
    }
    return @"GET";
}

- (NSString *)requestMethodName
{
    if (_requestMethodName == nil) {
        return [self httpMethod];
    }
    return _requestMethodName;
}

- (NSString *)baseURL
{
    if (!_baseURL) {
        _baseURL = KLNetworkConfigure.shareInstance.generalServer;
    }
    return _baseURL;
}

- (NSString *)base64ToString:(NSString *)string
{
    NSData *tempstrdata = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [tempstrdata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)md5To32BitString:(NSString *)string
{
    const char *cStr = [string UTF8String];         // 先转为UTF_8编码的字符串
    unsigned char digest[CC_MD5_DIGEST_LENGTH];     // 设置一个接受字符数组
    CC_MD5( cStr, (int)strlen(cStr), digest );      // 把str字符串转换成为32位的16进制数列，存到了result这个空间中
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];   // 将16字节的16进制转成32字节的16进制字符串
    }
    return [result uppercaseString];                // 大写字母字符串
}

- (void)dealloc
{
    if (KLNetworkConfigure.shareInstance.enableDebug) {
        NSLog(@"%@ dealloc", self.class);
    }
}

@end
