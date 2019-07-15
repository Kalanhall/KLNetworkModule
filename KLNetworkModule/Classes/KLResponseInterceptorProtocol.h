//
//  KLResponseInterceptorProtocol.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KLNetworkResponse;

/** 网络响应返回前的拦截协议 */
@protocol KLResponseInterceptorProtocol <NSObject>

- (void)validatorResponse:(KLNetworkResponse *)rsp;

@end
