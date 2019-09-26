//
//  NetConfigure.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 参数配置类 */
@interface KLNetworkConfigure : NSObject

/** 公共参数 */
@property (nonatomic, strong, nullable) NSDictionary <NSString *, NSString *> *generalParameters;
/** 动态公共参数*/
@property (nonatomic, copy  , nullable) NSDictionary <NSString *, NSString *> * (^generalDynamicParameters)(void);
/** 静态公共请求头 */
@property (nonatomic, strong, nullable) NSDictionary <NSString *, NSString *> *generalHeaders;
/** 动态公共请求头 parameters请求参数实体，参数用于加密依赖请求参数的需求*/
@property (nonatomic, copy  , nullable) NSDictionary <NSString *, NSString *> *(^generalDynamicHeaders)(NSDictionary *parameters);
/** 所有请求统一回调方法 */
@property (nonatomic, copy  , nullable) void (^responseUnifiedCallBack)(_Nullable id response);
/** 服务器地址 */
@property (nonatomic, copy  , nonnull) NSString *generalServer;
/** 与后端约定的请求成功code，默认为 200 */
@property (nonatomic, copy, nullable) NSString * respondeSuccessCode;
/** 与后端约定的请求结果状态字段, 默认 code, status */
@property (nonatomic, copy, nonnull) NSArray <NSString *> *respondeSuccessKeys;
/** 与后端约定的请求结果数据字段集合, 默认 data */
@property (nonatomic, copy, nonnull) NSArray <NSString *> *respondeDataKeys;
/** 与后端约定的请求结果消息字段集合, 默认 message, msg */
@property (nonatomic, copy, nonnull) NSArray <NSString *> *respondeMsgKeys;
/** 是否为调试模式（默认 NO, 当为 YES 时，会输出 网络请求日志） */
@property (nonatomic, assign) BOOL enableDebug;

+ (_Nonnull instancetype)shareInstance;
/** 添加公共请求参数 */
+ (void)addGeneralParameter:(NSString * _Nonnull)sKey value:(id _Nonnull )sValue;
/** 移除请求参数 */
+ (void)removeGeneralParameter:(NSString * _Nonnull)sKey;

@end

NS_ASSUME_NONNULL_END
