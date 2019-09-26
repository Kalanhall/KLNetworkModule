//
//  KLNetworkResponse.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLNetworkConstant.h"

NS_ASSUME_NONNULL_BEGIN

/** 网络响应类 */
@interface KLNetworkResponse : NSObject

/** 服务器返回状态 */
@property (nonatomic, assign, readonly) KLNetworkResponseStatus status;
/** 服务器返回经处理的数据 */
@property (nonatomic, copy  , readonly) id JSONObject;
/** 便捷取值，JSONObject下如果有data字段 */
@property (nonatomic, copy  , readonly) id data;
/** 服务器返回原始数据 */
@property (nonatomic, copy  , readonly) NSData *rawData;
/** 网络请求异常信息实体 */
@property (nullable, nonatomic, copy, readonly) NSError *error;
/** 服务器返回状态码 */
@property (nonatomic, assign, readonly) NSInteger statueCode;
/** 服务器返回消息 */
@property (nonatomic, copy  , readonly) NSString *message;
/** 服务器返回请求ID */
@property (nonatomic, copy  , readonly) NSString *requestId;
/** 当前请求实体 */
@property (nonatomic, copy  , readonly) NSURLRequest *request;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                   status:(KLNetworkResponseStatus)status;

- (nonnull instancetype)initWithRequestId:(nonnull NSNumber *)requestId
                                  request:(nonnull NSURLRequest *)request
                             responseData:(nullable NSData *)responseData
                                    error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
