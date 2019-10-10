# KLNetworkModule

[![CI Status](https://img.shields.io/travis/574068650@qq.com/KLNetworkModule.svg?style=flat)](https://travis-ci.org/574068650@qq.com/KLNetworkModule)
[![Version](https://img.shields.io/cocoapods/v/KLNetworkModule.svg?style=flat)](https://cocoapods.org/pods/KLNetworkModule)
[![License](https://img.shields.io/cocoapods/l/KLNetworkModule.svg?style=flat)](https://cocoapods.org/pods/KLNetworkModule)
[![Platform](https://img.shields.io/cocoapods/p/KLNetworkModule.svg?style=flat)](https://cocoapods.org/pods/KLNetworkModule)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```ruby

// HTTPS证书路径
KLNetworkConfigure.shareInstance.certificatePath = [NSBundle.mainBundle pathForResource:@"example.cer" ofType:nil];
// 全局静态公参
KLNetworkConfigure.shareInstance.generalParameters = @{@"uuid" : @"1CB2134B7439A8A05C44D2E78CBFD3DE"};

// 全局动态公参
KLNetworkConfigure.shareInstance.generalDynamicParameters = ^NSDictionary<NSString *,id> * _Nonnull{
    return @{@"userId" : @"32855", @"userTypeId" : @"44bd15964b49474c94a6c5979c8e3318"};
};

// 全局静态请求头参数设置
KLNetworkConfigure.shareInstance.generalHeaders = @{@"Platform" : @"iOS", @"uuid" : @"1CB2134B7439A8A05C44D2E78CBFD3DE"};

// 全局动态请求头参数设置，token，用户信息等
KLNetworkConfigure.shareInstance.generalDynamicHeaders = ^NSDictionary<NSString *,NSString *> * _Nonnull(NSDictionary * _Nonnull parameters) {
    return @{@"token" : @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.K4IenxWMAWd+9SPsuSPmGw==.eyJleHAiOjE1Njk4MjQxMDYxMTAsInBheWxvYWQiOiJcIjMyODU1XzE1Njk4MjQxMDYxMTBcIiJ9.oZzISkcZFRL1X81OQzZSou5gy1okMaT6TUsNkYJFRVY",
             @"sign" : @"2BE0EB601F039ED7EE9ED472787F1DD4"
    };
};

KLNetworkConfigure.shareInstance.responseUnifiedCallBack = ^(id _Nullable response) {
    NSLog(@"请求统一回调方法，处理统一异常码等");
};

// 全局域名配置
KLNetworkConfigure.shareInstance.generalServer = @"http://t.weather.sojson.com"; 
// 控制台输出
KLNetworkConfigure.shareInstance.enableDebug = YES;
// 与后端约定的请求结果状态字段, 默认 code, status
KLNetworkConfigure.shareInstance.respondeSuccessKeys = @[@"code", @"status"];   
// 与后端约定的请求结果消息字段集合, 默认 message, msg
KLNetworkConfigure.shareInstance.respondeMsgKeys = @[@"message", @"msg"];
// 与后端约定的请求结果数据字段集合, 默认 data
KLNetworkConfigure.shareInstance.respondeDataKeys = @[@"data", @"conten"];
// 与后端约定的请求成功code，默认为 200
KLNetworkConfigure.shareInstance.respondeSuccessCode = @"200";

// 请求示例1
KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
request.method = KLNetworkRequestMethodGET;
request.path = @"/api/weather/city/101030100";
request.normalParams = @{@"city" : @"101030100"};
[KLNetworkModule.shareManager sendRequest:request complete:^(KLNetworkResponse * _Nullable response) {
    if (response.status == KLNetworkResponseStatusSuccess) {
        // 成功处理
    } else {
        // 失败处理
    }
}];

// 请求示例2
[KLNetworkModule.shareManager sendRequestWithConfigBlock:^(KLNetworkRequest * _Nullable request) {
    request.method = KLNetworkRequestMethodGET;
    request.baseURL = @"http://www.exemple.com"; // 优先级高于generalServer 全局域名配置
    request.path = @"/api/getlist";
    request.normalParams = @{@"pageIndex" : @(1), @"pageSize" : @(20)};
    request.contenType = KLNetworkContenTypeJSON;           // 请求头类型
    request.serializerType = KLNetworkSerializerTypeJSON;   // 请求解析器，JSON序列化
} complete:^(KLNetworkResponse * _Nullable response) {
    if (response.status == KLNetworkResponseStatusSuccess) {
        // 成功处理
    } else {
        // 失败处理
    }
}];

// 异步并行队列请求
[KLNetworkModule.shareManager sendChainRequest:^(KLNetworkChainRequest * _Nullable chainRequest) {
    // 第一个请求
    [chainRequest onFirst:^(KLNetworkRequest * _Nullable request) {
        request.path = @"/api/weather/city/101030100";
        request.normalParams = @{@"city" : @"101030100"};
    }];
    // 第二个请求
    [chainRequest onNext:^(KLNetworkRequest * _Nullable request, KLNetworkResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
        // 获取到上一个请求的返回值 responseObject
        request.path = @"/api/weather/city/101030100";
        request.normalParams = @{@"city" : @"101030100"};
    }];
    
} complete:^(NSArray<KLNetworkResponse *> * _Nullable responseObjects, BOOL isSuccess) {
    NSLog(@"队列结束回调，如果中途有接口失败则终止");
}];

// 异步串行队列请求
[KLNetworkModule.shareManager sendGroupRequest:^(KLNetworkGroupRequest * _Nullable groupRequest) {
    for (NSInteger i = 0; i < 3; i ++) {
        KLNetworkRequest *request = [[KLNetworkRequest alloc] init];
        request.path = @"/api/weather/city/101030100";
        request.normalParams = @{@"city" : @"101030100"};
        [groupRequest addRequest:request];
    }
} complete:^(NSArray<KLNetworkResponse *> * _Nullable responseObjects, BOOL isSuccess) {
    NSLog(@"队列结束回调，如果中途有接口失败不终止，结果按请求顺序返回");
}];

```

## Requirements

## Installation

KLNetworkModule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KLNetworkModule', '~> 2.0.1'
```

## Author

'Kalan' ,'Kalanhall@163.com'

## License

KLNetworkModule is available under the MIT license. See the LICENSE file for more info.
