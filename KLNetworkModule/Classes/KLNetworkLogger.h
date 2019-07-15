//
//  KLNetworkLogger.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KLNetworkRequest;

@interface KLNetworkLogger : NSObject

/** 输出签名 */
+ (void)logSignInfoWithString:(NSString *)sign;
/** 请求参数 */
+ (void)logDebugInfoWithRequest:(KLNetworkRequest *)request;
/** 响应数据输出 */
+ (void)logDebugInfoWithTask:(NSURLSessionTask *)sessionTask data:(NSData *)data error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
