//
//  DSWeChatLoginManager.m
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/2.
//

#import "DSWeChatLoginManager.h"
//#import <LDZFWechatOpenSDK/WXApi.h>

@implementation DSWeChatLoginManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DSWeChatLoginManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)signInWithWeChat {
//    if ([WXApi isWXAppInstalled]) {
//        NSLog(@"微信未安装。");
//    } else {
//        NSLog(@"微信已安装");
//    }
}


@end
