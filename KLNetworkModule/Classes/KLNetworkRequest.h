//
//  Request.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLNetworkConstant.h"

NS_ASSUME_NONNULL_BEGIN

/** 网络请求参数数据类 */
@interface KLNetworkRequest : NSObject

/** 请求 Base URL，优先级高于 generalServer，仅限于当前请求模型，请求后释放 */
@property (nonatomic,   copy) NSString *baseURL;
/** 请求路径 /service/todosoming */
@property (nonatomic,   copy) NSString *requestURL;
/** 请求头，默认为nil */
@property (nonatomic, strong) NSDictionary *requestHeader;
/** 参数加密类型 默认不加密 */
@property (nonatomic, assign) KLEncryptType encryptType;
/** 请求参数，加密参数 不指定加密类型时，同normalParams混用 */
@property (nonatomic, strong) NSDictionary *encryptParams;
/** 请求参数，不用加密 默认为nil */
@property (nonatomic, strong) NSDictionary *normalParams;
/** 请求方式 默认为 KLNetworkRequestTypePost */
@property (nonatomic, assign) KLNetworkRequestType requestMethod;
/** 请求内容类型 默认为 KLNetworkRequestTypePost */
@property (nonatomic, assign) KLNetworkRequestContenType requestContenType;
/** 请求方式 默认为 KLNetworkRequestSerializerHTTP */
@property (nonatomic, assign) KLNetworkRequestSerializer requestSerializer;
/** 请求方式string */
@property (nonatomic,   copy) NSString *requestMethodName;
/** 请求超时时间 默认 30s */
@property (nonatomic, assign) NSTimeInterval reqeustTimeoutInterval;
/** api 版本号，默认 1.0 */
@property (nonatomic,   copy) NSString *apiVersion;
/** 重试次数，默认为 1 */
@property (nonatomic, assign) UInt8 retryCount NS_UNAVAILABLE;

/** 生成请求实体 @return 请求对象*/
- (NSURLRequest *)generateRequest;

@end

NS_ASSUME_NONNULL_END
