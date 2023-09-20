//
//  GTweenN.m
//  AmenUIKit_Example
//
//  Created by zhuyuhui on 2022/2/25.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import "GTweenN.h"

static const float frameRace = 60;

@interface GTweenN() {
    NSTimer         *_timer;
    NSTimeInterval  _oldTime;
    
    GTweenNStatus    _status;
    NSTimeInterval  _timeLeft;
}

@end

@implementation GTweenN
//
//- (void)checkTimer
//{
//    if (!_timer || !_timer.isValid) {
//        _oldTime = [NSDate date].timeIntervalSince1970;
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1/frameRace
//                                                  target:self
//                                                selector:@selector(update)
//                                                userInfo:nil
//                                                 repeats:YES];
//    }
//}
//
//
//- (void)start {
//    [self checkTimer];
//}
//
//- (void)stop
//{
//    [_timer invalidate];
//}
//
//- (void)update
//{
//    NSDate *date = [NSDate date];
//    NSTimeInterval time = date.timeIntervalSince1970;
//    
//    if (![self update:time - _oldTime]) {
//        [self stop];
//    }
//
//    _oldTime = time;
//}
//
//- (BOOL)update:(NSTimeInterval)delta
//{
//    BOOL check, isForword;
//    if (_status == GTweenNStatusPlayForword) {
//        _timeLeft += delta;
//        check = _timeLeft >= _duration + _delay;
//        isForword = true;
//    }else if (_status == GTweenNStatusPlayBackword) {
//        _timeLeft -= delta;
//        check = _timeLeft < 0;
//        isForword = false;
//    }else {
//        return NO;
//    }
//    if (check) {
//        float p = [self.ease ease:isForword ? 1 : 0];
//        [_properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [obj progress:p target:_target];
//        }];
//        [self.onUpdate invoke];
//        if (self.isLoop) {
//            [self.onLoop invoke];
//            [self initializeTween:isForword];
//            return YES;
//        }else {
//            [self.onComplete invoke];
//            _status = GTweenStatusStop;
//            return NO;
//        }
//    }else {
//        float p = [self.ease ease:MAX((_timeLeft-_delay)/_duration, 0)];
//        [_properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [obj progress:p target:_target];
//        }];
//        [self.onUpdate invoke];
//        return YES;
//    }
//}


//- (BOOL)update:(NSTimeInterval)delta
//{
//    // 设置帧数量
//    NSArray *values = [LdzfYXEasing calculateFrameFromValue:contentOffsetFromValue toValue:contentOffsetToValue func:IUCubicEaseOut frameCount:frameRace];
//
//}
@end
