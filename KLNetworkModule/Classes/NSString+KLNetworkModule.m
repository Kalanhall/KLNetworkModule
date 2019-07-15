//
//  NSString+KLNetworkModule.m
//  HttpManager
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "NSString+KLNetworkModule.h"

@implementation NSString (KLNetworkModule)

- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
