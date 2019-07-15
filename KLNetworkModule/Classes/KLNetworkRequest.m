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

@implementation KLNetworkRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestMethod = KLNetworkRequestTypePost;
        _reqeustTimeoutInterval = 30.0;
        _encryptParams = @{};
        _normalParams = @{};
        _requestHeader = @{};
        _retryCount = 1;
        _apiVersion = @"1.0";
        
    }
    return self;
}

/**
 生成请求

 @return NSURLRequest
 */
- (NSURLRequest *)generateRequest {
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = [self reqeustTimeoutInterval];
    serializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSMutableURLRequest *request = [serializer requestWithMethod:[self httpMethod] URLString:[self.baseURL stringByAppendingString:self.requestURL] parameters:[self generateRequestBody] error:NULL];
    // 请求头
    NSMutableDictionary *header = request.allHTTPHeaderFields.mutableCopy;
    if (!header)
    {
        header = [[NSMutableDictionary alloc] init];
    }
    [header addEntriesFromDictionary:[KLNetworkConfigure shareInstance].generalHeaders];
    request.allHTTPHeaderFields = header;
    
    return request.copy;
}

/** 公共请求参数 @return 请求参数字典 */
- (NSDictionary *)generateRequestBody {
    NSDictionary *commonDic = [KLNetworkConfigure shareInstance].generalParameters;
    return commonDic;
}

- (NSString *)httpMethod {
    KLNetworkRequestType type = [self requestMethod];
    switch (type)
    {
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

- (NSString *)baseURL {
    if (!_baseURL) {
        _baseURL = [KLNetworkConfigure shareInstance].generalServer;
    }
    return _baseURL;
}

- (void)dealloc {
    if ([KLNetworkConfigure shareInstance].enableDebug) {
        NSLog(@"dealloc: %@", ([self class]));
    }
}

@end
