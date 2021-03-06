//
//  KLAppDelegate.m
//  KLNetworkModule
//
//  Created by 574068650@qq.com on 07/15/2019.
//  Copyright (c) 2019 574068650@qq.com. All rights reserved.
//

#import "KLAppDelegate.h"
#import <KLNetworkModule/KLNetwork.h>

@implementation KLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // 全局静态公参
//    KLNetworkConfigure.shareInstance.generalParameters = @{@"uuid" : @"1CB2134B7439A8A05C44D2E78CBFD3DE"};
    
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
        NSLog(@"请求统一回调方法");
    };
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
