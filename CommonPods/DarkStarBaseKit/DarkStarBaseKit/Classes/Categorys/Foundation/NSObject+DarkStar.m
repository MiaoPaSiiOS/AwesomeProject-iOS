//
//  NSObject+DarkStar.m
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "NSObject+DarkStar.h"
#import <UIKit/UIKit.h>

@implementation NSObject (DarkStar)

#pragma mark - UIWindow | UIViewController

+ (nullable UIWindow *)ds_window {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

- (nullable UIViewController *)ds_topViewController {
    UIWindow * window = [NSObject ds_window];
    return [self ds_topViewController:window.rootViewController];
}

- (nullable UIViewController *)ds_topViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self ds_topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self ds_topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self ds_topViewController:rootViewController.presentedViewController];
    }
    return rootViewController;
}


#pragma mark - JSONValue | JSONString
-(id)ds_JSONValue {
    if (!self || ![self isKindOfClass:NSString.class]) {
        return nil;
    }
    NSString *str = (NSString *)self;
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err || !jsonObject) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return jsonObject;
}

-(NSString *)ds_JSONString {
    if (!self || ![NSJSONSerialization isValidJSONObject:self]) {
        return nil;
    }
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&err];
    if (err || !jsonData) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
