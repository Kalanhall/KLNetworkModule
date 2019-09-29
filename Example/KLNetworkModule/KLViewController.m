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
}

// TODO: 发送请求
- (IBAction)sendRequest:(id)sender {
        [self sendBasicRequest];
    //    [self sendChainRequest];
    //    [self sendGroupRequest];
}

/**
 基础请求
 */
- (void)sendBasicRequest {
    KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
    request.contenType = KLNetworkContenTypeJSON;
    request.method = KLNetworkRequestMethodGET;
    request.path = @"/api/weather/city/101030100";
    request.normalParams = @{@"city" : @"101030100"};
    request.encryptType = KLEncryptTypeBase64;
    request.encryptParams = @{@"base64" : @[@"1", @"2"]};

    [KLNetworkModule.shareManager sendRequest:request complete:^(KLNetworkResponse * _Nullable response) {

    }];
}

/**
 队列请求
 */
- (void)sendChainRequest {
    [KLNetworkModule.shareManager sendChainRequest:^(KLNetworkChainRequest * _Nullable chainRequest) {
        [chainRequest onFirst:^(KLNetworkRequest * _Nullable request) {
            request.path = @"/api/weather/city/101030100";
            request.method = KLNetworkRequestMethodGET;
        }];
        
        [chainRequest onNext:^(KLNetworkRequest * _Nullable request, KLNetworkResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
            request.baseURL = @"http://api.map.baidu.com";
            request.path = @"/location/ip?ak=9zNKGguAbdNC6xwD7syftt533eIf7cSn&callback=showLocation";
            request.method = KLNetworkRequestMethodGET;
        }];
        
    } complete:^(NSArray<KLNetworkResponse *> * _Nullable responseObjects, BOOL isSuccess) {
        NSLog(@"队列结束回调");
    }];
}

- (void)sendGroupRequest {
    [KLNetworkModule.shareManager sendGroupRequest:^(KLNetworkGroupRequest * _Nullable groupRequest) {
        for (NSInteger i = 0; i < 3; i ++) {
            KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
            request.baseURL = @"http://api.map.baidu.com";
            request.path = @"/location/ip?ak=9zNKGguAbdNC6xwD7syftt533eIf7cSn&callback=showLocation";
            request.method = KLNetworkRequestMethodPOST;
            request.normalParams = @{@"normalParams" : @"normalParams"};
            request.encryptParams = @{@"encryptParams" : @[@"1", @"2"]};
            request.encryptType = KLEncryptTypeMD5;
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
