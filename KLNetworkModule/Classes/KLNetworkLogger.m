//
//  HttpLogger.m
//  HttpManager
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkLogger.h"
#import "KLNetworkConstant.h"
#import "KLNetworkRequest.h"
#import "NSString+KLNetworkModule.h"

#define NSLog(format, ...) fprintf(stderr, "%s", [[NSString stringWithFormat:@"%@", [NSString stringWithFormat:format, ## __VA_ARGS__]] UTF8String])

@implementation KLNetworkLogger

/**
 输出签名
 */
+ (void)logSignInfoWithString:(NSString *)sign {
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       签名参数          "
                                  @"                    *\n**************************************************************\n\n"];
    [logString appendFormat:@"%@", sign];
    [logString appendFormat:@"\n\n**************************************************************\n*                         签名参数                            "
     @"*\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
}

/** 请求参数 */
+ (void)logDebugInfoWithRequest:(KLNetworkRequest *)request {
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start     "
                                  @"                   *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"Method:\t\t\t%@\n", [request requestMethodName]];
    [logString appendFormat:@"Version:\t\t%@\n", request.apiVersion];
    [logString appendFormat:@"Service:\t\t%@\n", request.requestURL];
    [logString appendFormat:@"Params:\n%@", request.encryptParams];
    [logString appendFormat:@"\n\nHTTP URL:\n\t%@", request.baseURL];
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        "
     @"*\n**************************************************************\n"];
    NSLog(@"%@", logString);
}

/**  响应数据输出 */
+ (void)logDebugInfoWithTask:(NSURLSessionTask *)sessionTask data:(NSData *)data error:(NSError *)error{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response     "
                                  @"                   =\n==============================================================\n\n"];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)sessionTask.response;
    NSURLRequest *request = sessionTask.originalRequest;
    
    [logString appendFormat:@"\nHTTP URL:\n\t%@", request.URL];
    [logString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    
    NSString *jsonString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    if (jsonString.length > 0) {
        NSArray *pas = [jsonString componentsSeparatedByString:@"&"];
        for (NSString *key in pas) {
            NSArray *p2 = [key componentsSeparatedByString:@"="];
            // 解密加密参数
            if (p2.count >= 2 && [p2[0] isEqualToString:@"params2"])
            {
                jsonString = p2[1];
                jsonString = [jsonString base64DecodedString];
            }
            else {
                // 公共参数
            }
        }
    }
    
    [logString appendFormat:@"\n\nHTTP Body:\t%@", jsonString.stringByRemovingPercentEncoding ?: @"\t\t\t\tN/A"];
    
    [logString appendFormat:@"\nStatus:\t%ld\t(%@)\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    if (error) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        "
     @"=\n==============================================================\n"];
    
    NSLog(@"%@", logString);
}

@end
