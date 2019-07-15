//
//  KLNetworkModule+Validate.m
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkModule+Validate.h"

@implementation KLNetworkModule (Validate)

+ (void)registerResponseInterceptor:(nonnull Class)cls {
    if (![cls conformsToProtocol:@protocol(KLResponseInterceptorProtocol)])
    {
        return;
    }
    
    [KLNetworkModule unregisterResponseInterceptor:cls];
    
    KLNetworkModule *share = [KLNetworkModule shareManager];
    [share.responseInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterResponseInterceptor:(nonnull Class)cls{
    KLNetworkModule *share = [KLNetworkModule shareManager];
    
    for (id obj in share.responseInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.responseInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}

+ (void)registerRequestInterceptor:(nonnull Class)cls{
    if (![cls conformsToProtocol:@protocol(KLRequestInterceptorProtocol)])
    {
        return;
    }
    
    [KLNetworkModule unregisterRequestInterceptor:cls];
    
    KLNetworkModule *share = [KLNetworkModule shareManager];
    [share.requestInterceptorObjectArray addObject:[cls new]];
}

+ (void)unregisterRequestInterceptor:(nonnull Class)cls{
    KLNetworkModule *share = [KLNetworkModule shareManager];
    for (id obj in share.requestInterceptorObjectArray)
    {
        if ([obj isKindOfClass:[cls class]])
        {
            [share.requestInterceptorObjectArray removeObject:obj];
            break;
        }
    }
}

@end
