//
//  NetConfigure.m
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkConfigure.h"

@implementation KLNetworkConfigure

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static KLNetworkConfigure *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _enableDebug = NO;
        _respondeMsgKeys     = @[@"message", @"msg"];
        _respondeDataKeys    = @[@"data"];
        _respondeSuccessKeys = @[@"code", @"status"];
    }
    return self;
}

// MARK: 接口
/** 添加公共请求参数 */
+ (void)addGeneralParameter:(NSString *)sKey value:(id)sValue {
    KLNetworkConfigure *manager = KLNetworkConfigure.shareInstance;
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    mDict[sKey] = sValue;
    [mDict addEntriesFromDictionary:manager.generalParameters];
    manager.generalParameters = mDict.copy;
}

/** 移除请求参数 */
+ (void)removeGeneralParameter:(NSString *)sKey {
    KLNetworkConfigure *manager = KLNetworkConfigure.shareInstance;
    NSMutableDictionary *mDict = manager.generalParameters.mutableCopy;
    [mDict removeObjectForKey:sKey];
    manager.generalParameters = mDict.copy;
}

// MARK: 私有方法
- (NSString *)respondeSuccessCode {
    if (!_respondeSuccessCode) {
        _respondeSuccessCode = @"200";
    }
    return _respondeSuccessCode;
}

@end
