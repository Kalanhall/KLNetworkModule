//
//  KLNetworkChainRequest.m
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkChainRequest.h"
#import "KLNetworkRequest.h"
#import "KLNetworkResponse.h"

@interface KLNetworkChainRequest()

@property (nonatomic, strong) NSMutableArray<NextBlock> *nextBlockArray;
@property (nonatomic, strong) NSMutableArray<KLNetworkResponse *> *responseArray;
@property (nonatomic, copy  ) GroupResponseBlock completeBlock;

@end

@implementation KLNetworkChainRequest

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];
    
    return self;
}

- (KLNetworkChainRequest *)onFirst:(RequestConfigBlock)firstBlock {
    NSAssert(firstBlock != nil, @"The first block for chain requests can't be nil.");
    NSAssert(_nextBlockArray.count == 0, @"The `-onFirst:` method must called befault `-onNext:` method");
    _runningRequest = [KLNetworkRequest new];
    firstBlock(_runningRequest);
    return self;
}

- (KLNetworkChainRequest *)onNext:(NextBlock)nextBlock {
    NSAssert(nextBlock != nil, @"The next block for chain requests can't be nil.");
    [_nextBlockArray addObject:nextBlock];
    return self;
}


- (BOOL)onFinishedOneRequest:(KLNetworkRequest *)request response:(nullable KLNetworkResponse *)responseObject {
    BOOL isFinished = NO;
    [_responseArray addObject:responseObject];
    // 失败
    if (responseObject.status == KLNetworkResponseStatusError) {
        _completeBlock(_responseArray.copy, NO);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    // 正常完成
    if (_responseArray.count > _nextBlockArray.count) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
        return isFinished;
    }
    /// 继续运行
    _runningRequest = [KLNetworkRequest new];
    NextBlock nextBlock = _nextBlockArray[_responseArray.count - 1];
    BOOL isSent = YES;
    nextBlock(_runningRequest, responseObject, &isSent);
    if (!isSent) {
        _completeBlock(_responseArray.copy, YES);
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    return isFinished;
}

- (void)cleanCallbackBlocks {
    _runningRequest = nil;
    _completeBlock = nil;
    [_nextBlockArray removeAllObjects];
}

@end
