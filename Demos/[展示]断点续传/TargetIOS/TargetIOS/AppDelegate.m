//
//  AppDelegate.m
//  TargetIOS
//
//  Created by zhuyuhui on 2022/8/23.
//

#import "AppDelegate.h"
#import <DoraemonKit/DoraemonKit.h>
#import "ESTabBarController.h"
#import "ESLaunchViewController.h"
#import <NrHWDownloadManager/NrHWDownloadManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    kWeakSelf
    [self showLaunchVCWith:^{
        kStrongSelf
        [strongSelf createWindowRootVC:0];
    }];
#ifdef DEBUG
    [[DoraemonManager shareInstance] install];
#endif
    return YES;
}

#pragma mark - 创建lanuchVC
/*
 先显示启动页,这样后续可以获得正确的safeAreaInsets
 [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
 */
- (void)showLaunchVCWith:(void (^)(void))result {
    kTabBarHeight;
    ESLaunchViewController *rootVC = [[ESLaunchViewController alloc] init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (result) {
            result();
        }
    });
}

#pragma mark - 创建rootVC
- (void)createWindowRootVC:(NSInteger)index {
    ESTabBarController *rootVC = [[ESTabBarController alloc] init];
    NrNavigationController *navRoot = [[NrNavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = navRoot;
    [self.window makeKeyAndVisible];
}


// 应用处于后台，所有下载任务完成调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    [HWDownloadManager shareManager].backgroundSessionCompletionHandler = completionHandler;
}

@end
