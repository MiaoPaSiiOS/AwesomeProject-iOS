//
//  AppDelegate+AMENScreenshotCheck.m
//  Amen
//
//  Created by zhuyuhui on 2022/6/30.
//

#import "AppDelegate+AMENScreenshotCheck.h"

@implementation AppDelegate (AMENScreenshotCheck)
- (void)checkScreenShot {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTakeScreenshot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)userTakeScreenshot {
    NSLog(@"检测到截屏了！！！");
}

@end
