//
//  GCDSemaphore.m
//  GCD
//
//  http://home.cnblogs.com/u/YouXianMing/
//  https://github.com/YouXianMing
//
//  Created by XianMingYou on 15/3/15.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import "GCDSemaphore.h"

@interface GCDSemaphore ()

@property (strong, readwrite, nonatomic) dispatch_semaphore_t dispatchSemaphore;

@end

@implementation GCDSemaphore
/*
 dispatch_semaphore_signal 调用一次,信号量+1, dispatch_semaphore_wait 调用一次,信号量-1,当信号量 <0时,当前线程就会卡主,没法往下执行,直到dispatch_semaphore_signal被调用,使得信号量+1,才会继续往下执行.

 作者：洧中苇_4187
 链接：https://www.jianshu.com/p/2682e425cc83
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        /*
         （1）
         dispatch_semaphore_t dispatch_semaphore_create(long value);
         传入的参数为long，输出一个dispatch_semaphore_t类型且值为value的信号量。
         值得注意的是，这里的传入的参数value必须大于或等于0，否则dispatch_semaphore_create会返回NULL。
         */
        self.dispatchSemaphore = dispatch_semaphore_create(0);
    }
    
    return self;
}

- (instancetype)initWithValue:(long)value {
    
    self = [super init];
    
    if (self) {
        /*
         （1）
         dispatch_semaphore_t dispatch_semaphore_create(long value);
         传入的参数为long，输出一个dispatch_semaphore_t类型且值为value的信号量。
         值得注意的是，这里的传入的参数value必须大于或等于0，否则dispatch_semaphore_create会返回NULL。
         */
        self.dispatchSemaphore = dispatch_semaphore_create(value);
    }
    
    return self;
}

- (BOOL)signal {
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}

- (void)wait {
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end
