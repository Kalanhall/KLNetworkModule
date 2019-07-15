//
//  KLNetworkGroupRequest.m
//  KLNetworkModule
//
//  Created by kalan on 2018/4/9.
//  Copyright © 2018年 kalan. All rights reserved.
//

#import "KLNetworkGroupRequest.h"
#import "KLNetworkConstant.h"
#import "KLNetworkResponse.h"

@interface KLNetworkGroupRequest()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, assign) NSUInteger finishedCount;
@property (nonatomic, assign, getter=isFailed) BOOL failed;
@property (nonatomic,   copy) GroupResponseBlock completeBlock;
@end

@implementation KLNetworkGroupRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray new];
        _responseArray = [NSMutableArray new];
    }
    return self;
}

- (void)addRequest:(KLNetworkRequest *)request {
    [_requestArray addObject:request];
}

- (BOOL)onFinishedOneRequest:(KLNetworkRequest *)request response:(nullable KLNetworkResponse *)responseObject {
    BOOL isFinished = NO;
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    if (responseObject) {
        [_responseArray addObject:responseObject];
    }
    _failed |= (responseObject.status == KLNetworkResponseStatusError);
    
    _finishedCount ++;
    if (_finishedCount == _requestArray.count) {
        if (_completeBlock) {
            _completeBlock(_responseArray.copy, !_failed);
        }
        [self cleanCallbackBlocks];
        isFinished = YES;
    }
    dispatch_semaphore_signal(_lock);
    return isFinished;
}

- (void)cleanCallbackBlocks {
    _completeBlock = nil;
}

// MARK: 懒加载
- (dispatch_semaphore_t)lock {
    if (!_lock) {
        _lock = dispatch_semaphore_create(1);
    }
    return _lock;
}

@end
