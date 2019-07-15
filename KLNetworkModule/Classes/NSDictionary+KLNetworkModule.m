//
//  NSDictionary+KLNetworkModule.m
//  HttpManager
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "NSDictionary+KLNetworkModule.h"

@implementation NSDictionary (KLNetworkModule)

- (NSString *)toJsonString {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
