//
//  KLNetworkConstant.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#ifndef KLNetworkConstant_h
#define KLNetworkConstant_h

#import "KLRequestInterceptorProtocol.h"
#import "KLResponseInterceptorProtocol.h"

@class KLNetworkResponse,KLNetworkRequest,KLNetworkGroupRequest,KLNetworkChainRequest;

typedef NS_ENUM (NSUInteger, KLNetworkRequestMethod){
    KLNetworkRequestMethodGET = 0,
    KLNetworkRequestMethodPOST,
    KLNetworkRequestMethodPUT,
    KLNetworkRequestMethodDELETE,
    KLNetworkRequestMethodPATCH
};

typedef NS_ENUM (NSUInteger, KLNetworkResponseStatus){
    KLNetworkResponseStatusError = 0,
    KLNetworkResponseStatusSuccess
};

typedef NS_ENUM (NSUInteger, KLEncryptType){
    KLEncryptTypeBase64 = 0,
    KLEncryptTypeMD5            // 32位加密&大写字母
};

typedef NS_ENUM (NSUInteger, KLNetworkContenType){
    KLNetworkContenTypeFormURLEncoded = 0,
    KLNetworkContenTypeJSON           = 1,
    KLNetworkContenTypeFormData       = 2,
    KLNetworkContenTypeXML            = 3
};

// 响应配置 Block
typedef void (^KLNetworkResponseBlock)(KLNetworkResponse * _Nullable response);
typedef void (^GroupResponseBlock)(NSArray<KLNetworkResponse *> * _Nullable responseObjects, BOOL isSuccess);
typedef void (^NextBlock)(KLNetworkRequest * _Nullable request, KLNetworkResponse * _Nullable responseObject, BOOL * _Nullable isSent);

// 请求配置 Block
typedef void (^RequestConfigBlock)(KLNetworkRequest * _Nullable request);
typedef void (^GroupRequestConfigBlock)(KLNetworkGroupRequest * _Nullable groupRequest);
typedef void (^ChainRequestConfigBlock)(KLNetworkChainRequest * _Nullable chainRequest);

#endif /* KLNetworkConstant_h */
