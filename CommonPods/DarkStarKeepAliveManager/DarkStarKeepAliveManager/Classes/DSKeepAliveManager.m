
#import "DSKeepAliveManager.h"
#import "DSKeepAliveBGTool.h"

@interface DSKeepAliveManager ()
/// 功能开关
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) DSKeepAliveBGTool *tool;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int applyTimes;

@end

@implementation DSKeepAliveManager

/// 单例
+ (nonnull instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)start {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - NSNotificationCenter UIApplicationWillEnterForegroundNotification & UIApplicationDidEnterBackgroundNotification
///进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endBackgroundTask];
}

///进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (self.enable) {
        if (self.tool == nil) {
            self.tool = [[DSKeepAliveBGTool alloc] init];
        }
        [self.tool start];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(timerMethod:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

#pragma mark - Private
/// 结束后台播放任务
- (void)endBackgroundTask {
    if (self.tool) {
        [self.tool stop];
    }
    if (self.timer) {
        [self.timer invalidate];//停止定时器
        self.timer = nil;
    }
    _applyTimes = 0;
}

#pragma mark - Timer Method
///定时器
- (void)timerMethod:(NSTimer *)paramSender {
    _applyTimes++;
    if (_applyTimes >= kKLTime) {
        [self endBackgroundTask];
    }
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    NSLog(@"已执行%d秒", _applyTimes);
}

#pragma mark - Lazy Load

- (BOOL)enable{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kKLEnable] && ![[[NSUserDefaults standardUserDefaults] objectForKey:kKLEnable] isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}

@end
