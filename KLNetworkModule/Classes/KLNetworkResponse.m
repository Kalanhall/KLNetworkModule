//
//  KLNetworkResponse.m
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkResponse.h"
#import "KLNetworkConfigure.h"

@interface KLNetworkResponse()

/** 服务器返回状态 */
@property (nonatomic, assign) KLNetworkResponseStatus status;
/** 服务器返回经处理的数据 */
@property (nonatomic, copy  ) id JSONObject;
/** 便捷取值，JSONObject下如果有data字段 */
@property (nonatomic, copy  ) id data;
/** 服务器返回原始数据 */
@property (nonatomic, copy  ) NSData *rawData;
/** 网络请求异常信息实体 */
@property (nullable, nonatomic, copy) NSError *error;
/** 服务器返回状态码 */
@property (nonatomic, assign) NSInteger statueCode;
/** 服务器返回消息 */
@property (nonatomic, copy  ) NSString *message;
/** 服务器返回请求ID */
@property (nonatomic, copy  ) NSString *requestId;
/** 当前请求实体 */
@property (nonatomic, copy  ) NSURLRequest *request;

@end

@implementation KLNetworkResponse

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(KLNetworkResponseStatus)status {
    self = [super init];
    if (self)
    {
        self.requestId = requestId.stringValue;
        self.request = request;
        self.rawData = responseData;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.JSONObject = dic;
        // 服务器返回字段不确定，根据实际情况进行调整
        __block id value = nil;
        [KLNetworkConfigure.shareInstance.respondeSuccessKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [dic valueForKey:key];
            if (value) *stop = YES;         // 命中即停止
        }];
        id code = value;
        self.statueCode = [code integerValue];
        
        value = nil;
        [KLNetworkConfigure.shareInstance.respondeDataKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [dic valueForKey:key];
            if (value) *stop = YES;         // 命中即停止
        }];
        self.data = value;
        
        value = nil;
        [KLNetworkConfigure.shareInstance.respondeMsgKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [dic valueForKey:key];
            if (value) *stop = YES;         // 命中即停止
        }];
        self.message = value;
        
        if (self.statueCode == KLNetworkConfigure.shareInstance.respondeSuccessCode.integerValue) {
            self.status = KLNetworkResponseStatusSuccess;
        } else {
            self.status = KLNetworkResponseStatusError;
        }
        
        if (KLNetworkConfigure.shareInstance.responseUnifiedCallBack) {
            KLNetworkConfigure.shareInstance.responseUnifiedCallBack(self.JSONObject);
        }
    }
    return self;
}

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error {
    self = [super init];
    if (self)
    {
        self.status = KLNetworkResponseStatusError;
        self.requestId = requestId.stringValue;
        self.request = request;
        self.rawData = responseData;
        self.JSONObject = error.localizedDescription;
        self.statueCode = error.code;
        self.error = error;
        
        if (KLNetworkConfigure.shareInstance.responseUnifiedCallBack) {
            KLNetworkConfigure.shareInstance.responseUnifiedCallBack(error);
        }
    }
    return self;
}

@end
