//
//  NSString+KLNetworkModule.h
//  HttpManager
//
//  Created by kalan on 2018/1/4.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KLNetworkModule)

/**  转换为Base64编码 */
- (NSString *)base64EncodedString;
/** 将Base64编码还原  */
- (NSString *)base64DecodedString;

@end
