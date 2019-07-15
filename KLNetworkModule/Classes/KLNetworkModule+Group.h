//
//  KLNetworkModule+Group.h
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkModule.h"
#import "KLNetworkConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLNetworkModule (Group)

- (NSString *_Nullable)sendGroupRequest:(nullable GroupRequestConfigBlock)configBlock
                      complete:(nullable GroupResponseBlock)completeBlock;

- (void)cancelGroupRequest:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
