//
//  KLNetworkModule+Chain.m
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkModule+Chain.h"
#import "KLNetworkChainRequest.h"
#import "KLNetworkModule+Group.h"
#import "KLNetworkRequest.h"
#import <objc/runtime.h>

@implementation KLNetworkModule (Chain)

- (NSMutableDictionary *)chainRequestDictionary {
    return objc_getAssociatedObject(self, @selector(chainRequestDictionary));
}

- (void)setChainRequestDictionary:(NSMutableDictionary *)mutableDictionary {
    objc_setAssociatedObject(self, @selector(chainRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)sendChainRequest:(nullable ChainRequestConfigBlock)configBlock complete:(nullable GroupResponseBlock)completeBlock {
    KLNetworkChainRequest *chainRequest = [[KLNetworkChainRequest alloc] init];
    if (configBlock) {
        configBlock(chainRequest);
    }
    
    if (chainRequest.runningRequest) {
        if (completeBlock) {
            [chainRequest setValue:completeBlock forKey:@"_completeBlock"];
        }
        
        NSString *uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self sendChainRequst:chainRequest uuid:uuid];
        return uuid;
    }
    return nil;
}

- (void)sendChainRequst:(KLNetworkChainRequest *)chainRequest uuid:(NSString *)uuid {
    if (chainRequest.runningRequest != nil) {
        if (![self chainRequestDictionary]) {
            [self setChainRequestDictionary:[[NSMutableDictionary alloc] init]];
        }
        __weak __typeof(self) weakSelf = self;
        NSString *taskID = [self sendRequest:chainRequest.runningRequest
                                    complete:^(KLNetworkResponse *_Nullable response) {
                                        __weak __typeof(self) strongSelf = weakSelf;
                                        if ([chainRequest onFinishedOneRequest:chainRequest.runningRequest response:response]) {
                                        } else {
                                            if (chainRequest.runningRequest != nil) {
                                                [strongSelf sendChainRequst:chainRequest uuid:uuid];
                                            }
                                        }
                                    }];
        [self chainRequestDictionary][uuid] = taskID;
    }
}

- (void)cancelChainRequest:(NSString *)taskID {
    // 根据 Chain id 找到 taskid
    NSString *tid = [self chainRequestDictionary][taskID];
    [self cancelRequestWithRequestID:tid];
}

@end
