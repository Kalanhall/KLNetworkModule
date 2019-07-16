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

@property (nonatomic, copy, readwrite) NSData *rawData;
@property (nonatomic, assign, readwrite) KLNetworkResponseStatus status;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, assign, readwrite) NSInteger statueCode;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSURLRequest *request;

@end

@implementation KLNetworkResponse

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(KLNetworkResponseStatus)status {
    self = [super init];
    if (self)
    {
        self.requestId = [requestId unsignedIntegerValue];
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
        self.requestId = [requestId unsignedIntegerValue];
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
        self.content = @"网络异常，请稍后再试";
        self.statueCode = error.code;
        return;
    }
    
    if (self.rawData.length > 0) {
        NSDictionary *dic = [self jsonWithData:self.rawData];
        self.status = KLNetworkResponseStatusSuccess;
        self.content = [self processCotnentValue:dic];
    
        // 服务器返回字段不确定，根据实际情况进行调整
        id code = [dic valueForKey:@"code"] ? : [dic valueForKey:@"status"];
        self.statueCode = [code integerValue];
    } else {
        self.statueCode = NSURLErrorUnknown;
        self.status = KLNetworkResponseStatusError;
        self.content = @"未知错误";
    }
}

/** 临时 返回数据处理 */
- (id)processCotnentValue:(id)content {
    if ([content isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *contentDict = ((NSDictionary *)content).mutableCopy;
        [contentDict removeObjectForKey:@"result"];
        
        if ([contentDict[@"data"] isKindOfClass:[NSNull class]])
        {
            [contentDict removeObjectForKey:@"data"];
        }
        
        return contentDict.copy;
    }
    return content;
}

@end
