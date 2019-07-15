//
//  KLNetworkModule+Validate.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLNetworkModule (Validate)

/**
 请求前的拦截器
 
 @param cls 实现 KLRequestInterceptorProtocol 协议的 实体类
 可以在该实体类中做请求前的处理
 */
+ (void)registerRequestInterceptor:(nonnull Class)cls;
+ (void)unregisterRequestInterceptor:(nonnull Class)cls;

/**
 返回数据前的拦截器
 
 @param cls 实现 ResponseInterceptorProtocol 协议的 实体类
 可以在该实体类中做统一的数据验证
 */
+ (void)registerResponseInterceptor:(nonnull Class)cls;
+ (void)unregisterResponseInterceptor:(nonnull Class)cls;

@end

NS_ASSUME_NONNULL_END
