//
//  KLNetworkModule+Group.m
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkModule+Group.h"
#import "KLNetworkGroupRequest.h"
#import "KLNetworkRequest.h"
#import <objc/runtime.h>

@implementation KLNetworkModule (Group)

- (NSMutableDictionary *)groupRequestDictionary {
    return objc_getAssociatedObject(self, @selector(groupRequestDictionary));
}

- (void)setGroupRequestDictionary:(NSMutableDictionary *)mutableDictionary {
    objc_setAssociatedObject(self, @selector(groupRequestDictionary), mutableDictionary, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)sendGroupRequest:(nullable GroupRequestConfigBlock)configBlock
                      complete:(nullable GroupResponseBlock)completeBlock {
    
    if (![self groupRequestDictionary]) {
        [self setGroupRequestDictionary:[[NSMutableDictionary alloc] init]];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    KLNetworkGroupRequest *groupRequest = [[KLNetworkGroupRequest alloc] init];
    configBlock(groupRequest);
    
    if (groupRequest.requestArray.count > 0) {
        if (completeBlock) {
            [groupRequest setValue:completeBlock forKey:@"_completeBlock"];
        }
        
        [groupRequest.responseArray removeAllObjects];
        for (KLNetworkRequest *request in groupRequest.requestArray) {
            NSString *taskID = [self sendRequest:request complete:^(KLNetworkResponse * _Nullable response) {
                if ([groupRequest onFinishedOneRequest:request response:response]) {
                    NSLog(@"finish");
                }
            }];
            [tempArray addObject:taskID];
        }
        NSString *uuid = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self groupRequestDictionary][uuid] = tempArray.copy;
        return uuid;
    }
    return nil;
}

- (void)cancelGroupRequest:(NSString *)taskID {
    NSArray *group = [self groupRequestDictionary][taskID];
    for (NSString *tid in group) {
        [self cancelRequestWithRequestID:tid];
    }
}

@end
