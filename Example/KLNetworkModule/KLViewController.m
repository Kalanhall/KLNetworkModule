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
    [self sendBasicRequest];
//    [self sendChainRequest];
//    [self sendGroupRequest];
    KLNetworkConfigure.shareInstance.enableDebug = YES;
}

/**
 基础请求
 */
- (void)sendBasicRequest {
    KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
    request.requestMethod = KLNetworkRequestTypeGet;
    request.requestURL = @"/api/weather/city/101030100";
    request.encryptParams = @{@"encryptParams" : @[@"1", @"2"]};
    request.normalParams = @{@"normalParams" : @"normalParams"};
    
    [KLNetworkModule.shareManager sendRequest:request complete:^(KLNetworkResponse * _Nullable response) {
        
    }];
    
    //    [KLNetworkModule.shareManager sendRequestWithConfigBlock:^(KLNetworkRequest * _Nullable request) {
    //        request.requestURL = @"/api/weather/city/101030100";
    //        request.normalParams = @{};
    //        request.requestMethod = KLNetworkRequestTypeGet;
    //    } complete:^(KLNetworkResponse * _Nullable response) {
    //        if (response.status == KLNetworkResponseStatusSuccess) {
    //
    //        }
    //    }];
}

/**
 队列请求
 */
- (void)sendChainRequest {
    [KLNetworkModule.shareManager sendChainRequest:^(KLNetworkChainRequest * _Nullable chainRequest) {
        [chainRequest onFirst:^(KLNetworkRequest * _Nullable request) {
            request.requestURL = @"/api/weather/city/101030100";
            request.requestMethod = KLNetworkRequestTypeGet;
        }];
        
        [chainRequest onNext:^(KLNetworkRequest * _Nullable request, KLNetworkResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
            request.baseURL = @"http://api.map.baidu.com";
            request.requestURL = @"/location/ip?ak=9zNKGguAbdNC6xwD7syftt533eIf7cSn&callback=showLocation";
            request.requestMethod = KLNetworkRequestTypeGet;
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
            request.requestURL = @"/location/ip?ak=9zNKGguAbdNC6xwD7syftt533eIf7cSn&callback=showLocation";
            request.requestMethod = KLNetworkRequestTypePost;
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
