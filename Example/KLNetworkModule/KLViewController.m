//
//  KLViewController.m
//  KLNetworkModule
//
//  Created by 574068650@qq.com on 07/15/2019.
//  Copyright (c) 2019 574068650@qq.com. All rights reserved.
//

#import "KLViewController.h"
#import <KLNetworkModule/KLNetwork.h>

@interface KLViewController ()

@end

@implementation KLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KLNetworkConfigure.shareInstance.generalServer = @"http://t.weather.sojson.com";
    KLNetworkConfigure.shareInstance.enableDebug = YES;
    KLNetworkConfigure.shareInstance.respondeSuccessKeys = @[@"code", @"status"];   /** 与后端约定的请求结果状态字段, 默认 code, status */
    KLNetworkConfigure.shareInstance.respondeMsgKeys = @[@"message", @"msg"];       /** 与后端约定的请求结果消息字段集合, 默认 message, msg */
    KLNetworkConfigure.shareInstance.respondeDataKeys = @[@"data", @"conten"];      /** 与后端约定的请求结果数据字段集合, 默认 data */
    KLNetworkConfigure.shareInstance.respondeSuccessCode = @"200";                  /** 与后端约定的请求成功code，默认为 200 */
}

// TODO: 发送请求
- (IBAction)sendRequest:(id)sender {
//        [self sendBasicRequest];
//        [self sendChainRequest];
        [self sendGroupRequest];
}

/**
 基础请求
 */
- (void)sendBasicRequest {
    KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
    request.path = @"/api/weather/city/101030100";
    request.normalParams = @{@"city" : @"101030100"};
    [KLNetworkModule.shareManager sendRequest:request complete:^(KLNetworkResponse * _Nullable response) {
        if (response.status == KLNetworkResponseStatusSuccess) {
            // 成功处理
        } else {
            // 失败处理
        }
    }];
    
//    [KLNetworkModule.shareManager sendRequestWithConfigBlock:^(KLNetworkRequest * _Nullable request) {
//        request.method = KLNetworkRequestMethodPOST;
//        request.serializerType = KLNetworkSerializerTypeJSON;
//        request.contenType = KLNetworkContenTypeJSON;
//        request.baseURL = @"http://ec2-52-83-156-42.cn-northwest-1.compute.amazonaws.com.cn:30001";
//        request.path = @"/app/gateway/30088/iot/video/likeCommand";
//        request.normalParams = @{@"commandType" : @(1), @"videoId" : @"11756866726150061209"};
//    } complete:^(KLNetworkResponse * _Nullable response) {
//
//    }];
}

/**
 队列请求
 */
- (void)sendChainRequest {
    [KLNetworkModule.shareManager sendChainRequest:^(KLNetworkChainRequest * _Nullable chainRequest) {
        [chainRequest onFirst:^(KLNetworkRequest * _Nullable request) {
            request.path = @"/api/weather/city/101030100";
            request.normalParams = @{@"city" : @"101030100"};
        }];
        
        [chainRequest onNext:^(KLNetworkRequest * _Nullable request, KLNetworkResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
            request.path = @"/api/weather/city/101030100";
            request.normalParams = @{@"city" : @"101030100"};
        }];
        
    } complete:^(NSArray<KLNetworkResponse *> * _Nullable responseObjects, BOOL isSuccess) {
        NSLog(@"队列结束回调");
    }];
}

- (void)sendGroupRequest {
    [KLNetworkModule.shareManager sendGroupRequest:^(KLNetworkGroupRequest * _Nullable groupRequest) {
        for (NSInteger i = 0; i < 3; i ++) {
            KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
            request.path = @"/api/weather/city/101030100";
            request.normalParams = @{@"city" : @"101030100"};
            [groupRequest addRequest:request];
        }
    } complete:^(NSArray<KLNetworkResponse *> * _Nullable responseObjects, BOOL isSuccess) {
        NSLog(@"队列结束回调");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
