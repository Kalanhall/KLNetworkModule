//
//  KLRequestInterceptorProtocol.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLNetworkRequest;

/** 请求前的拦截协议 */
@protocol KLRequestInterceptorProtocol <NSObject>

- (BOOL)needRequestWithRequest:(KLNetworkRequest *)request;
- (NSData *)cacheDataFromRequest:(KLNetworkRequest *)request;

@end
