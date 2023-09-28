//
//  AppDelegate.m
//  DSDemo-OC
//
//  Created by zhuyuhui on 2023/9/19.
//

#import "AppDelegate.h"
#import <DoraemonKit/DoraemonKit.h>
#import "REUITabBarController.h"
#import "REUINavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"time============%@",NSHomeDirectory());
    /// 初始化UI之前配置
    [self _configureApplication:application initialParamsBeforeInitUI:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self changeWindowRootVC:0];
    
    /// 初始化UI后配置
    [self _configureApplication:application initialParamsAfterInitUI:launchOptions];

    
#ifdef DEBUG
    [[DoraemonManager shareInstance] install];
#endif
    return YES;
}

#pragma mark - 在初始化UI之前配置
- (void)_configureApplication:(UIApplication *)application initialParamsBeforeInitUI:(NSDictionary *)launchOptions
{
    /// 配置键盘
    [self _configureKeyboardManager];
    
    /// 配置文件夹
    [self _configureApplicationDirectory];
    
    /// 配置FMDB
    [self _configureFMDB];
    
}

/// 配置文件夹
- (void)_configureApplicationDirectory
{
    /// 创建doc
//    [MHFileManager createDirectoryAtPath:MHWeChatDocDirPath()];
//    /// 创建cache
//    [MHFileManager createDirectoryAtPath:MHWeChatCacheDirPath()];
//
//    NSLog(@"MHWeChatDocDirPath is [ %@ ] \n MHWeChatCacheDirPath is [ %@ ]" , MHWeChatDocDirPath() , MHWeChatCacheDirPath());
}

/// 配置键盘管理器
- (void)_configureKeyboardManager {
//    IQKeyboardManager.sharedManager.enable = YES;
//    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
//    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}

/// 配置FMDB
- (void) _configureFMDB
{
//    [[FMDatabaseQueue sharedInstance] inDatabase:^(FMDatabase *db) {
//        NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:SBApplicationVersionKey];
//        if (![version isEqualToString:SB_APP_VERSION]) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"senba_empty_1.0.0" ofType:@"sql"];
//            NSString *sql  = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//            /// 执行文件
//            if (![db executeStatements:sql]) {
//                SBLogLastError(db);
//            }
//        }
//    }];
}

#pragma mark - 在初始化UI之后配置
- (void)_configureApplication:(UIApplication *)application initialParamsAfterInitUI:(NSDictionary *)launchOptions
{
    /// 配置ActionSheet
//    [LCActionSheet mh_configureActionSheet];
    
    /// 预先配置平台信息
//    [SBUMengService configureUMengPreDefinePlatforms];

    /// 监听切换根控制器的通知
//    [MHNotificationCenter addObserver:self selector:@selector(switchRootViewNoti:) name:MHSwitchRootViewControllerNotification object:nil];
    
    /// 配置H5
//    [SBConfigureManager configure];
    
    
    /// 配置讯飞语音
    [self _configIFlyMSC];
}

#pragma mark - 调试(DEBUG)模式下的工具条
- (void)_configDebugModelTools
{
    /// 显示FPS
//    [[JPFPSStatus sharedInstance] open];
    
    /// 打开调试按钮
//    [MHDebugTouchView sharedInstance];
//    /// CoderMikeHe Fixed: 切换了根控制器，切记需要将指示器 移到window的最前面
//    [self.window bringSubviewToFront:[MHDebugTouchView sharedInstance]];
}


/// 配置讯飞语音听写
- (void)_configIFlyMSC {
//
//    // 配置
//    // Set log level
//    [IFlySetting setLogFile:LVL_NONE];
//
//    // Set whether to output log messages in Xcode console
//    [IFlySetting showLogcat:NO];
//
//    // Set the local storage path of SDK
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [paths objectAtIndex:0];
//    [IFlySetting setLogFilePath:cachePath];
//
//    // Set APPID
//    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",IFLY_APPID_VALUE];
//
//    // Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
//    [IFlySpeechUtility createUtility:initString];
//
}



#pragma mark - 通知
- (void)switchRootViewNoti:(NSNotification *)noti {
//    self.window.rootViewController = [[AmenTabBarController alloc] init];

//    // The user has logged-in.
//    NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:MHApplicationVersionKey];
//    /// 版本不一样就先走 新特性界面
//    if (![version isEqualToString:MH_APP_VERSION]){
//        UIViewController *screen = [[CTMediator sharedInstance] mediator_AmenNewFeatureViewController:nil];
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:screen];
//    }else{
//        if ([AAM isLogin]) {
//            self.window.rootViewController = [[AmenTabBarController alloc] init];
//        } else {
//            UIViewController *screen = [[CTMediator sharedInstance] mediator_DSLoginViewController:nil];
//            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:screen];
//        }
//    }
}

#pragma mark- 获取appDelegate
+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - 创建rootVC
- (void)changeWindowRootVC:(NSInteger)index {
    REUITabBarController *tabBarController = [[REUITabBarController alloc] init];
    tabBarController.selectedIndex = index;
    self.window.rootViewController = [REGlobal sharedInstance].globalTbc = tabBarController;
}

- (void)goToTabWithIndex:(NSNumber*)idx {
    if (!idx) {
        return;
    }
    NSInteger index = idx.integerValue;
    //如果就是在index栈的情况下
    if ([REGlobal sharedInstance].globalTbc.selectedIndex == index) {
        [[DSCommonMethods findTopViewController].navigationController popToRootViewControllerAnimated:YES];
    } else {
        //如果是在一级页面，则直接跳转到index；非一级页面，给个延迟再跳转
        if (![DSCommonMethods findTopViewController].tabBarController.tabBar.hidden) {
            [[REGlobal sharedInstance].globalTbc enterHomeWithIndex:idx];
        } else {
            [[DSCommonMethods findTopViewController].navigationController popToRootViewControllerAnimated:YES];
            dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , 0.05 * NSEC_PER_SEC ) ;
            dispatch_after ( time , dispatch_get_main_queue ( ) , ^ {
                [[REGlobal sharedInstance].globalTbc enterHomeWithIndex:idx];
            });
        }
    }
}




#pragma mark - App 生命周期方法
@end
