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

@property (nonatomic, copy  ) NSData *rawData;
@property (nonatomic, assign) KLNetworkResponseStatus status;
@property (nonatomic, copy  ) id content;
@property (nonatomic, copy  ) id data;
@property (nonatomic, copy  , nonnull) NSString *message;
@property (nonatomic, assign) NSInteger statueCode;
@property (nonatomic, copy  ) NSString *requestId;
@property (nonatomic, copy  ) NSURLRequest *request;

@end

@implementation KLNetworkResponse

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(KLNetworkResponseStatus)status
{
    self = [super init];
    if (self) {
        self.requestId = @([requestId unsignedIntegerValue]).stringValue;
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:nil];
    }
    return self;
}

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error
{
    self = [super init];
    if (self) {
        self.requestId = @([requestId unsignedIntegerValue]).stringValue;
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:error];
    }
    return self;
}

- (void)inspectionResponse:(NSError *)error
{
    if (error) {
        self.status = KLNetworkResponseStatusError;
        self.content = nil;
        self.message = @"网络异常，请稍后再试";
        self.statueCode = error.code;
        return;
    }
    
    self.content = [NSJSONSerialization JSONObjectWithData:self.rawData options:NSJSONReadingAllowFragments error:NULL];
    __block id value = nil;
    // MARK: 状态码获取
    [KLNetworkConfigure.shareInstance.respondeSuccessKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        value = [self.content valueForKey:key];
        if (value) *stop = YES;
    }];
    id code = value;
    self.statueCode = [code integerValue];
    
    if (self.statueCode == KLNetworkConfigure.shareInstance.respondeSuccessCode.integerValue) {
        // 默认200为业务处理成功标识码
        self.status = KLNetworkResponseStatusSuccess;
        [KLNetworkConfigure.shareInstance.respondeDataKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [self.content valueForKey:key];
            if (value) *stop = YES;
        }];
        self.data = value;
        [KLNetworkConfigure.shareInstance.respondeMsgKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [self.content valueForKey:key];
            if (value) *stop = YES;
        }];
        self.message = value ? : @"No message";
    } else {
        // 其他业务异常码入口
        self.status = KLNetworkResponseStatusError;
        self.message =  @"Unknow Error";
    }
    
    if (KLNetworkConfigure.shareInstance.responseUnifiedCallBack) {
        KLNetworkConfigure.shareInstance.responseUnifiedCallBack(self.content);
    }
}

@end
