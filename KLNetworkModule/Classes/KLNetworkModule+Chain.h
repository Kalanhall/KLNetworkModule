//
//  KLNetworkModule+Chain.h
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLNetworkModule (Chain)

- (NSString *)sendChainRequest:(nullable ChainRequestConfigBlock)configBlock
                      complete:(nullable GroupResponseBlock)completeBlock;

- (void)cancelChainRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
