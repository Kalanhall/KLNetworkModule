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
        self.timeoutInterval = 30.0;
        self.version = @"1.0";
    }
    return self;
}

/** 生成请求实体 @return 请求对象*/
- (NSURLRequest *)generateRequest
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer willChangeValueForKey:@"timeoutInterval"];
    [serializer setTimeoutInterval:self.timeoutInterval];
    [serializer didChangeValueForKey:@"timeoutInterval"];
    [serializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    NSDictionary *parameters = [self generateRequestBody];
    NSString *urlString = [self.baseURL stringByAppendingString:self.path];
    NSMutableURLRequest *request = [serializer requestWithMethod:[self httpMethod] URLString:urlString parameters:parameters error:NULL];
    // 请求头
    NSMutableDictionary *header = request.allHTTPHeaderFields.mutableCopy;
    if (!header) {
        header = [[NSMutableDictionary alloc] init];
    }
    // ContenType
    [header setValue:self.httpContenType forKey:@"Content-Type"];
    // 请求时插入的请求头
    [header addEntriesFromDictionary:self.header];
    // 静态公共请求头
    [header addEntriesFromDictionary:KLNetworkConfigure.shareInstance.generalHeaders];
    // 动态公共请求头
    if (KLNetworkConfigure.shareInstance.generalDynamicHeaders)
        [header addEntriesFromDictionary:KLNetworkConfigure.shareInstance.generalDynamicHeaders(parameters)];
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
    KLNetworkRequestMethod type = [self method];
    switch (type) {
        case KLNetworkRequestMethodGET:
            return @"GET";
        case KLNetworkRequestMethodPOST:
            return @"POST";
        case KLNetworkRequestMethodPUT:
            return @"PUT";
        case KLNetworkRequestMethodDELETE:
            return @"DELETE";
        case KLNetworkRequestMethodPATCH:
            return @"PATCH";
        default:
            break;
    }
    return @"GET";
}

- (NSString *)httpContenType {
    switch (self.contenType) {
        case KLNetworkContenTypeFormURLEncoded:
            return @"application/x-www-form-urlencoded";
        case KLNetworkContenTypeJSON:
            return @"application/json";
        case KLNetworkContenTypeFormData:
            return @"multipart/form-data";
        case KLNetworkContenTypeXML:
            return @"application/xml";
        default:
            break;
    }
}

- (NSString *)methodName
{
    return [self httpMethod];
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
