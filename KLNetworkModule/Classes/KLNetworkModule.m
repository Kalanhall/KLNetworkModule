//
//  KLNetworkModule.m
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkModule.h"
#import <AFNetworking/AFNetworking.h>
#import "KLNetworkModule+Validate.h"
#import "KLNetworkLogger.h"
#import "KLNetworkConfigure.h"
#import "KLNetworkResponse.h"
#import "KLNetworkRequest.h"

@interface KLNetworkModule ()

@end

@implementation KLNetworkModule

+ (nonnull instancetype)shareManager {
    static dispatch_once_t onceToken;
    static KLNetworkModule *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _responseInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _reqeustDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 4;
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

 - (NSString *)sendRequest:(KLNetworkRequest *)request complete:(KLNetworkResponseBlock)result {
    // 拦截器处理
     if (![self needRequestInterceptor:request]) {
         if ([KLNetworkConfigure shareInstance].enableDebug) {
             NSLog(@"该请求已经取消");
         }
         return nil;
     }
     [KLNetworkLogger logDebugInfoWithRequest:request];
     return [self requestWithRequest:[request generateRequest]  complete:result];
}

- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull RequestConfigBlock)requestBlock complete:(nonnull KLNetworkResponseBlock) result{
    KLNetworkRequest *request = [KLNetworkRequest new];
    requestBlock(request);
    // 拦截器处理
    if (![self needRequestInterceptor:request]) {
        if ([KLNetworkConfigure shareInstance].enableDebug)
        {
            NSLog(@"该请求已经取消");
        }
        return nil;
    }
    [KLNetworkLogger logDebugInfoWithRequest:request];
    return [self requestWithRequest:[request generateRequest] complete:result];
}


/**
 取消一个网络请求
 
 @param requestID 请求id
 */
- (void)cancelRequestWithRequestID:(nonnull NSString *)requestID {
    NSURLSessionDataTask *requestOperation = self.reqeustDictionary[requestID];
    [requestOperation cancel];
    [self.reqeustDictionary removeObjectForKey:requestID];
}


/**
 取消很多网络请求
 
 @param requestIDList @[请求id,请求id]
 */
- (void)cancelRequestWithRequestIDList:(nonnull NSArray<NSString *> *)requestIDList {
    for (NSString *requestId in requestIDList){
        [self cancelRequestWithRequestID:requestId];
    }
}
#pragma - private

/**
 发起请求

 @param request NSURLRequest
 @param complete 回调
 @return requestId
 */
- (NSString *)requestWithRequest:(NSURLRequest *)request complete:(KLNetworkResponseBlock)complete {
    
    __block NSURLSessionDataTask *task = nil;
    task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self.reqeustDictionary removeObjectForKey:@([task taskIdentifier])];
        NSData *responseData = responseObject;
        [self requestFinishedWithBlock:complete task:task data:responseData error:error];
    }];
    
    NSString *requestId = [[NSString alloc] initWithFormat:@"%@", @([task taskIdentifier])];
    self.reqeustDictionary[requestId] = task;
    [task resume];
    return requestId;
}

- (void)requestFinishedWithBlock:(KLNetworkResponseBlock)blk task:(NSURLSessionTask *)task data:(NSData *)data error:(NSError *)error {
    if ([KLNetworkConfigure shareInstance].enableDebug){
        //打印返回参数
        [KLNetworkLogger logDebugInfoWithTask:task data:data error:error];
    }
    
    if (error){
        KLNetworkResponse *rsp = [[KLNetworkResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data error:error];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }
        blk ? blk(rsp) : nil;
    } else {
        KLNetworkResponse *rsp = [[KLNetworkResponse alloc] initWithRequestId:@([task taskIdentifier]) request:task.originalRequest responseData:data status:KLNetworkResponseStatusSuccess];
        for (id obj in self.responseInterceptorObjectArray)
        {
            if ([obj respondsToSelector:@selector(validatorResponse:)])
            {
                [obj validatorResponse:rsp];
                break;
            }
        }
        blk ? blk(rsp) : nil;
    }
}

- (BOOL)needRequestInterceptor:(KLNetworkRequest *)request {
    BOOL need = YES;
    for (id obj in self.requestInterceptorObjectArray) {
        if ([obj respondsToSelector:@selector(needRequestWithRequest:)]){
            need = [obj needRequestWithRequest:request];
            if (need)
            {
                break;
            }
        }
    }
    return need;
}

@end
