//
//  KLNetworkChainRequest.h
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLNetworkConstant.h"

NS_ASSUME_NONNULL_BEGIN

@class KLNetworkRequest, KLNetworkResponse;

@interface KLNetworkChainRequest : NSObject

@property (nonatomic, copy  , readonly) NSString *identifier;
@property (nonatomic, strong, readonly) KLNetworkRequest *runningRequest;

- (KLNetworkChainRequest *)onFirst:(RequestConfigBlock)firstBlock;
- (KLNetworkChainRequest *)onNext:(NextBlock)nextBlock;
- (BOOL)onFinishedOneRequest:(KLNetworkRequest *)request response:(nullable KLNetworkResponse *)responseObject;

@end

NS_ASSUME_NONNULL_END
