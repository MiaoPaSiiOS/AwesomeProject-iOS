//
//  NSObject+Nr.m
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "NSObject+Nr.h"
#import <UIKit/UIKit.h>

@implementation NSObject (Nr)
+ (nullable UIWindow *)nr_window {
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

- (nullable UIViewController *)nr_topViewController {
    UIWindow * window = [NSObject nr_window];
    return [self nr_topViewController:window.rootViewController];
}

- (nullable UIViewController *)nr_topViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self nr_topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self nr_topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self nr_topViewController:rootViewController.presentedViewController];
    }
    return rootViewController;
}



-(id)nr_JSONValue
{
    if (!self || ![self isKindOfClass:NSString.class]) {
        return nil;
    }
    NSString *str = (NSString *)self;
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err || !jsonObject) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return jsonObject;
}

-(NSString *)nr_JSONString
{
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
