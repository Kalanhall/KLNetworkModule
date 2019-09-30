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

/** 请求 Base URL，优先级高于 generalServer */
@property (nonatomic,   copy) NSString *baseURL;
/** 请求路径 /service/todosoming */
@property (nonatomic,   copy) NSString *path;

/** 请求头信息，默认为nil */
@property (nonatomic, strong) NSDictionary *header;
/** 请求参数，不用加密 默认为nil */
@property (nonatomic, strong) NSDictionary *normalParams;
/** 参数加密类型 默认不加密 */
@property (nonatomic, assign) KLEncryptType encryptType;
/** 请求参数，加密参数 不指定加密类型时，同normalParams混用 */
@property (nonatomic, strong) NSDictionary *encryptParams;

/** 请求方式 默认为 KLNetworkRequestMethodGET */
@property (nonatomic, assign) KLNetworkRequestMethod method;
/** 获取请求方式字符串名称 */
@property (nonatomic,   copy, readonly) NSString *methodName;
/** 标识MIME类型
    默认 application/x-www-form-urlencoded - KLNetworkContenTypeFormURLEncoded
 */
@property (nonatomic, assign) KLNetworkContenType contenType;
/** 标识序列化类型
    默认 KLNetworkSerializerTypeHTTP - AFHTTPRequestSerializer
 */
@property (nonatomic, assign) KLNetworkSerializerType serializerType;
/** 请求超时时间 默认 30s */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/** api 版本号，默认 1.0.0*/
@property (nonatomic,   copy) NSString *version;

/** 生成请求实体 @return 请求对象*/
- (NSURLRequest *)generateRequest;

@end

NS_ASSUME_NONNULL_END
