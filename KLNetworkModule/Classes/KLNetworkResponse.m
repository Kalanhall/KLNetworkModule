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
/** 服务器返回数据，成功则为字典类型，失败则为字符串 */
@property (nonatomic, copy  ) id content;
/** 便捷取值，content下如果有data字段 */
@property (nonatomic, copy  ) id data;
/** 服务器返回消息 */
@property (nonatomic, copy  , nonnull) NSString *message;
/** 服务器返回状态码 */
@property (nonatomic, assign) NSInteger statueCode;
@property (nonatomic, copy  ) NSString *requestId;
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
        self.requestId = [NSString stringWithFormat:@"%@", @([requestId unsignedIntegerValue])];
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:nil];
    }
    return self;
}

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error{
    self = [super init];
    if (self)
    {
        self.requestId = [NSString stringWithFormat:@"%@", @([requestId unsignedIntegerValue])];
        self.request = request;
        self.rawData = responseData;
        [self inspectionResponse:error];
    }
    return self;
}

- (id)jsonWithData:(NSData *)data { return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL]; }

- (void)inspectionResponse:(NSError *)error {
    if (error) {
        self.status = KLNetworkResponseStatusError;
        self.content = nil;
        self.message = @"网络异常，请稍后再试";
        self.statueCode = error.code;
        return;
    }
    
    if (self.rawData.length > 0) {
        self.content = [self jsonWithData:self.rawData];
        
        __block id value = nil;
        // MARK: ⚠️ 状态码获取
        [KLNetworkConfigure.shareInstance.respondeSuccessKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [self.content valueForKey:key];
            if (value) *stop = YES;
        }];
        id code = value;
        self.statueCode = [code integerValue];
        // MARK: ⚠️ 数据获取
        [KLNetworkConfigure.shareInstance.respondeDataKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [self.content valueForKey:key];
            if (value) *stop = YES;
        }];
        self.data = value;
        // MARK: ⚠️ 消息获取
        [KLNetworkConfigure.shareInstance.respondeMsgKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            value = [self.content valueForKey:key];
            if (value) *stop = YES;
        }];
        self.message = value ? : @"";
        
        if (self.statueCode == 200) {
            self.status = KLNetworkResponseStatusSuccess;
        } else {
            self.status = KLNetworkResponseStatusError;
        }
    } else {
        self.statueCode = NSURLErrorUnknown;
        self.status = KLNetworkResponseStatusError;
        self.content = nil;
        self.message = @"未知错误";
    }
    
    if (KLNetworkConfigure.shareInstance.responseUnifiedCallBack) {
        KLNetworkConfigure.shareInstance.responseUnifiedCallBack(self.content);
    }
}

@end
