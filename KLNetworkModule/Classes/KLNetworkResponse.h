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

@property (nonatomic, copy  , readonly) NSData *rawData;
@property (nonatomic, assign, readonly) KLNetworkResponseStatus status;
/** 服务器返回数据，成功则为字典类型，失败则为字符串 */
@property (nonatomic, copy  , readonly) id content;
/** 便捷取值，content下如果有data字段 */
@property (nonatomic, copy  , readonly) id data;
/** 服务器返回消息 */
@property (nonatomic, copy  , nonnull, readonly) NSString *message;
/** 服务器返回状态码 */
@property (nonatomic, assign, readonly) NSInteger statueCode;
@property (nonatomic, copy  , readonly) NSString *requestId;
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
