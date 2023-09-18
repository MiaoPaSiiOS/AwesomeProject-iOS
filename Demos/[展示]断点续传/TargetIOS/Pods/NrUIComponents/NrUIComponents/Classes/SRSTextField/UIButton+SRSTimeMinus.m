
#import "UIButton+SRSTimeMinus.h"
#import <objc/runtime.h>

@implementation UIButton (SRSTimeMinus)

- (void)startWithStartTime:(NSUInteger)time {
    if (time <= 0) {
        time = 60;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.enabled = NO;
        [self _circulate:time - 1];
    });
}

- (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.enabled = NO;
        [self _circulate:59];
    });
}

- (void)_circulate:(NSInteger)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (time < 0 || self.enabled) {
            self.enabled = YES;
            [self setTitle:@"重新发送" forState:UIControlStateNormal];
            return;
        }
        [self setTitle:[NSString stringWithFormat:@"%lds",(long)time] forState:UIControlStateDisabled];
        kWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            kStrongSelf
            [strongSelf _circulate:time-1];
        });
    });
}

- (void)stop {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.enabled = YES;
    });
}

@end
