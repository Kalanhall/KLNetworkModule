//
//  KLNetworkModule.h
//  KLNetworkModule
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//  网络请求类

#import <Foundation/Foundation.h>
#import "KLNetworkConstant.h"

NS_ASSUME_NONNULL_BEGIN

@class KLNetworkResponse,KLNetworkRequest,AFHTTPSessionManager;

@interface KLNetworkModule : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary * _Nullable reqeustDictionary;
@property (nonatomic, strong, readonly) AFHTTPSessionManager * _Nullable sessionManager;
@property (nonatomic, strong) NSMutableArray * _Nullable requestInterceptorObjectArray;
@property (nonatomic, strong) NSMutableArray * _Nullable responseInterceptorObjectArray;

- (instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)shareManager;

// MARK: - Nomal Request
/**
 @abstract  默认请求
 @param     request             请求实体类
 @param     result               响应结果
 @return    该请求对应的唯一 task id
 */
- (NSString *_Nullable)sendRequest:(nonnull KLNetworkRequest *)request complete:(nonnull KLNetworkResponseBlock)result;

/**
 @abstract  默认请求
 @param     requestBlock    请求配置 Block
 @param     result                  请求结果 Block
 @return    该请求对应的唯一 task id
 */
- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull RequestConfigBlock )requestBlock complete:(nonnull KLNetworkResponseBlock) result;

// MARK: - Upload Request
/**
 @abstract  上传请求
 @param     request              请求实体类
 @param     bodyData            上传数据
 @param     progress            上传进度回调
 @param     result                  响应结果
 @return    该请求对应的唯一 task id
 */
- (NSString *_Nullable)sendRequest:(nonnull KLNetworkRequest *)request fromData:(NSData *)bodyData progress:(void (^)(NSProgress *uploadProgress))progress complete:(nonnull KLNetworkResponseBlock)result;

/**
 @abstract  上传请求
 @param     requestBlock    请求配置 Block
 @param     bodyData            上传数据
 @param     progress            上传进度回调
 @param     result                 响应结果
 @return    该请求对应的唯一 task id
 */
- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull RequestConfigBlock)requestBlock fromData:(NSData *)bodyData progress:(void (^)(NSProgress *uploadProgress))progress complete:(nonnull KLNetworkResponseBlock)result;

// MARK: - Download Request
/**
 @abstract  下载请求
 @param     request             请求实体类
 @param     result                响应结果
 @param     destination     文件存储路径配置
 @param     progress           下载进度回调
 @return    该请求对应的唯一 task id
 */
- (NSString *_Nullable)sendRequest:(nonnull KLNetworkRequest *)request destination:(NSURL * (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination progress:(void (^)(NSProgress *downloadProgress))progress complete:(nonnull KLNetworkResponseBlock)result;

/**
 @abstract  下载请求
 @param     requestBlock     请求配置 Block
 @param     result                  请求结果 Block
 @param     destination       文件存储路径配置
 @param     progress             下载进度回调
 @return    该请求对应的唯一 task id
 */
- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull RequestConfigBlock)requestBlock destination:(NSURL * (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination progress:(void (^)(NSProgress *downloadProgress))progress complete:(nonnull KLNetworkResponseBlock)result;

// MARK: - Cancle Request
/**
 @abstract  单一取消请求
 @param     requestID 任务请求ID
 */
- (void)cancelRequestWithRequestID:(nonnull NSString *)requestID;

/**
 @abstract  批量取消请求
 @param     requestIDList 任务请求 ID 列表
 */
- (void)cancelRequestWithRequestIDList:(nonnull NSArray<NSString *> *)requestIDList;

@end

NS_ASSUME_NONNULL_END
