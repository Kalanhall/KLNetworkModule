//
//  KLNetworkGroupRequest.h
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KLNetworkRequest, KLNetworkResponse;

@interface KLNetworkGroupRequest : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <KLNetworkRequest *> *requestArray;
@property (nonatomic, strong, readonly) NSMutableArray <KLNetworkResponse *> *responseArray;

- (void)addRequest:(KLNetworkRequest *)request;
- (BOOL)onFinishedOneRequest:(KLNetworkRequest *)request response:(nullable KLNetworkResponse *)responseObject;

@end

NS_ASSUME_NONNULL_END

