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

@property (nonatomic, strong) NSMutableDictionary *reqeustDictionary;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation KLNetworkModule

+ (nonnull instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static KLNetworkModule *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _responseInterceptorObjectArray = [NSMutableArray arrayWithCapacity:3];
        _reqeustDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 10; // 同一IP最大并发数
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 返回二进制
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

// MARK: - 🔥 Nomal Request
 - (NSString *)sendRequest:(KLNetworkRequest *)request complete:(KLNetworkResponseBlock)result
{
    // 拦截器处理
     if (![self needRequestInterceptor:request]) {
         if (KLNetworkConfigure.shareInstance.enableDebug) NSLog(@"该请求已经取消");
         return nil;
     }
     [KLNetworkLogger logDebugInfoWithRequest:request];
     return [self requestWithRequest:[request generateRequest]  complete:result];
}

- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull RequestConfigBlock)requestBlock complete:(nonnull KLNetworkResponseBlock) result
{
    KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
    requestBlock(request);
    // 拦截器处理
    if (![self needRequestInterceptor:request]) {
        if (KLNetworkConfigure.shareInstance.enableDebug) NSLog(@"该请求已经取消");
        return nil;
    }
    [KLNetworkLogger logDebugInfoWithRequest:request];
    return [self requestWithRequest:[request generateRequest] complete:result];
}

- (NSString *)requestWithRequest:(NSURLRequest *)request complete:(KLNetworkResponseBlock)complete
{
    __block NSURLSessionDataTask *task = nil;
    task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error && [response isKindOfClass:NSHTTPURLResponse.class]) {
            // 重写ERROR，重新code
            NSHTTPURLResponse *rsp = (NSHTTPURLResponse *)response;
            error = [NSError errorWithDomain:error.localizedDescription code:rsp.statusCode userInfo:error.userInfo];
        }
        [self.reqeustDictionary removeObjectForKey:@([task taskIdentifier])];
        [self requestFinishedWithBlock:complete task:task data:responseObject error:error];
    }];
    
    NSString *requestId = [[NSString alloc] initWithFormat:@"%@", @([task taskIdentifier])];
    self.reqeustDictionary[requestId] = task;
    [task resume];
    return requestId;
}

// MARK: - 🔥 Upload Request
- (NSString *_Nullable)sendRequest:(nonnull KLNetworkRequest *)request fromData:(NSData *)bodyData progress:(void (^)(NSProgress *uploadProgress))progress complete:(nonnull KLNetworkResponseBlock)result
{
    // 拦截器处理
    if (![self needRequestInterceptor:request]) {
        if (KLNetworkConfigure.shareInstance.enableDebug) NSLog(@"该请求已经取消");
        return nil;
    }
    [KLNetworkLogger logDebugInfoWithRequest:request];
    return [self requestWithUploadRequest:[request generateRequest] fromData:bodyData progress:progress complete:result];
}

- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull RequestConfigBlock)requestBlock fromData:(NSData *)bodyData progress:(void (^)(NSProgress *uploadProgress))progress complete:(nonnull KLNetworkResponseBlock)result
{
    KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
    requestBlock(request);
    // 拦截器处理
    if (![self needRequestInterceptor:request]) {
        if (KLNetworkConfigure.shareInstance.enableDebug) NSLog(@"该请求已经取消");
        return nil;
    }
    [KLNetworkLogger logDebugInfoWithRequest:request];
    return [self requestWithUploadRequest:[request generateRequest] fromData:bodyData progress:progress complete:result];
}

- (NSString *)requestWithUploadRequest:(NSURLRequest *)request fromData:(NSData *)bodyData progress:(void (^)(NSProgress *uploadProgress))progress complete:(KLNetworkResponseBlock)complete
{
    __block NSURLSessionUploadTask *task = nil;
    task = [self.sessionManager uploadTaskWithRequest:request fromData:bodyData progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error && [response isKindOfClass:NSHTTPURLResponse.class]) {
            // 重写ERROR，重新code
            NSHTTPURLResponse *rsp = (NSHTTPURLResponse *)response;
            error = [NSError errorWithDomain:error.localizedDescription code:rsp.statusCode userInfo:error.userInfo];
        }
        
        [self.reqeustDictionary removeObjectForKey:@([task taskIdentifier])];
        
        /** ----- 自定义返回实体 ----- */
        NSMutableDictionary *result = NSMutableDictionary.dictionary;
        if (error == nil) {
            NSMutableDictionary *dic = NSMutableDictionary.dictionary;
            [dic setValue:response.URL.absoluteString forKey:@"uploadURL"];
            [result setValue:@(200) forKey:@"code"];
            [result setValue:dic forKey:@"data"];
            [result setValue:@"Upload Success" forKey:@"message"];
        } else {
            [result setValue:@(error.code) forKey:@"code"];
            [result setValue:error.domain forKey:@"message"];
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
        /** ----- 自定义返回实体 ----- */
        
        [self requestFinishedWithBlock:complete task:task data:data error:error];
    }];
    
    NSString *requestId = [[NSString alloc] initWithFormat:@"%@", @([task taskIdentifier])];
    self.reqeustDictionary[requestId] = task;
    [task resume];
    return requestId;
}

// MARK: - 🔥 Download Request
- (NSString *_Nullable)sendRequest:(nonnull KLNetworkRequest *)request destination:(NSURL * (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination progress:(void (^)(NSProgress *downloadProgress))progress complete:(nonnull KLNetworkResponseBlock)result
{
    // 拦截器处理
    if (![self needRequestInterceptor:request]) {
        if (KLNetworkConfigure.shareInstance.enableDebug) NSLog(@"该请求已经取消");
        return nil;
    }
    
    [KLNetworkLogger logDebugInfoWithRequest:request];
    return [self requestWithDownloadRequest:[request generateRequest] destination:destination progress:progress complete:result];
}

- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull RequestConfigBlock)requestBlock destination:(NSURL * (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination progress:(void (^)(NSProgress *downloadProgress))progress complete:(nonnull KLNetworkResponseBlock)result
{
    KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
    requestBlock(request);
    // 拦截器处理
    if (![self needRequestInterceptor:request]) {
        if (KLNetworkConfigure.shareInstance.enableDebug) NSLog(@"该请求已经取消");
        return nil;
    }
    
    [KLNetworkLogger logDebugInfoWithRequest:request];
    return [self requestWithDownloadRequest:[request generateRequest] destination:destination progress:progress complete:result];
}

- (NSString *)requestWithDownloadRequest:(NSURLRequest *)request destination:(NSURL * (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination progress:(void (^)(NSProgress *downloadProgress))progress complete:(KLNetworkResponseBlock)complete
{
    __block NSURLSessionDownloadTask *task = nil;
    task = [self.sessionManager downloadTaskWithRequest:request progress:progress destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error && [response isKindOfClass:NSHTTPURLResponse.class]) {
            // 重写ERROR，重新code
            NSHTTPURLResponse *rsp = (NSHTTPURLResponse *)response;
            error = [NSError errorWithDomain:error.localizedDescription code:rsp.statusCode userInfo:error.userInfo];
        }
        
        [self.reqeustDictionary removeObjectForKey:@([task taskIdentifier])];
        
        /** ----- 自定义返回实体 ----- */
        NSMutableDictionary *result = NSMutableDictionary.dictionary;
        if (error == nil) {
            NSMutableDictionary *dic = NSMutableDictionary.dictionary;
            [dic setValue:response.URL.absoluteString forKey:@"downloadURL"];
            [dic setValue:filePath.absoluteString forKey:@"filePath"];
            [result setValue:@(200) forKey:@"code"];
            [result setValue:dic forKey:@"data"];
            [result setValue:@"Download Success" forKey:@"message"];
        } else {
            [result setValue:@(error.code) forKey:@"code"];
            [result setValue:error.domain forKey:@"message"];
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
        /** ----- 自定义返回实体 ----- */
        
        [self requestFinishedWithBlock:complete task:task data:data error:error];
    }];
    
    NSString *requestId = [[NSString alloc] initWithFormat:@"%@", @([task taskIdentifier])];
    self.reqeustDictionary[requestId] = task;
    [task resume];
    return requestId;
}

// MARK: - 🔥 Finish Request
- (void)requestFinishedWithBlock:(KLNetworkResponseBlock)blk task:(NSURLSessionTask *)task data:(NSData *)data error:(NSError *)error
{
    if (KLNetworkConfigure.shareInstance.enableDebug) [KLNetworkLogger logDebugInfoWithTask:task data:data error:error];
    
    if (error) {
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

// MARK: - 🔥 Cancle Request
- (void)cancelRequestWithRequestID:(nonnull NSString *)requestID
{
    NSURLSessionDataTask *requestOperation = self.reqeustDictionary[requestID];
    [requestOperation cancel];
    [self.reqeustDictionary removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(nonnull NSArray<NSString *> *)requestIDList
{
    for (NSString *requestId in requestIDList){
        [self cancelRequestWithRequestID:requestId];
    }
}

// MARK: - 🔥 Intercept Request
- (BOOL)needRequestInterceptor:(KLNetworkRequest *)request
{
    BOOL need = YES;
    for (id obj in self.requestInterceptorObjectArray) {
        if ([obj respondsToSelector:@selector(needRequestWithRequest:)]) {
            need = [obj needRequestWithRequest:request];
            if (need) {
                break;
            }
        }
    }
    return need;
}

@end
