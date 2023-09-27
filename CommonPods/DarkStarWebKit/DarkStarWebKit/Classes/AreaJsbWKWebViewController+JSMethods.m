//
//  AreaJsbWKWebViewController+JSMethods.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import "AreaJsbWKWebViewController+JSMethods.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "MBProgressHUD.h"
@implementation AreaJsbWKWebViewController (JSMethods)

- (void)registerOtherWebCode {
    [self JSCallJSByNative];
    [self JSShowWating];
    [self JSGetAppInfo];
    [self JSGetNavigationBarHeight];
    [self JSSetScreenBrightness];
    [self JSEntrySysSettings];
    [self JSCanOpenURL];
    [self JSOpenURL];
}
#pragma mark - Private
- (void)_showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)_dismissHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
#pragma mark - JS通过调用该方法去 调用 JS 中注册的事件
-(void)JSCallJSByNative{
    kWeakSelf
    [self registerHandler:@"JSCallJSByNative" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        kStrongSelf
        NSDictionary *parameters = data;
        NSString *jsMethod = [parameters valueForKey:@"jsMethod"];
        NSDictionary *jsParameters = [parameters valueForKey:@"jsParameters"];
        [strongSelf callHandler:jsMethod data:jsParameters responseCallback:nil];
    }];
}


#pragma mark - 等待层
-(void)JSShowWating{
    kWeakSelf
    [self registerHandler:@"JSShowWating" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        kStrongSelf
        NSDictionary *waitDict = (NSDictionary *)data;
        NSString *strPara = [waitDict objectForKey:@"exit"];
        //1开启等待层,0关闭等待层
        if ([strPara isEqualToString:@"1"]) {
            [strongSelf _showHUD];
        } else {
            [strongSelf _dismissHUD];
        }
    }];
}

#pragma mark - 获取APP信息
- (void)JSGetAppInfo{
    kWeakSelf
    [self registerHandler:@"JSGetAppInfo" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        kStrongSelf
        NSDictionary *parameters = data;
        NSString *strType = [parameters valueForKey:@"strType"];
        NSDictionary *dictRespose=  [strongSelf appInfo:strType];
        if (responseCallback) {
            responseCallback(dictRespose);
        }
    }];
}

-(NSDictionary *)appInfo:(NSString *)type{
    DSDeviceInfo *dInfo = [DSDeviceInfo sharedInstance];
    NSString *value=@"";
    if ([type isEqualToString:@"deviceModel"]) {
        value = dInfo.deviceModel;
    }else if ([type isEqualToString:@"ostype"]){
        value =dInfo.ostype;
    }else if ([type isEqualToString:@"deviceName"]){
        value =dInfo.deviceName;
    }else if ([type isEqualToString:@"deviceid"]){
        value =dInfo.deviceid;
    }else if ([type isEqualToString:@"systemVersion"]){
        value =dInfo.systemVersion;
    }else if ([type isEqualToString:@"appID"]){
        value =dInfo.appID;
    }else if ([type isEqualToString:@"appVersion"]){
        value =dInfo.appVersion;
    }else if([type isEqualToString:@"allInfo"]){
        NSDictionary *dictAllInfo = @{@"deviceModel":dInfo.deviceModel,
                                      @"ostype":dInfo.ostype,
                                      @"deviceName":dInfo.deviceName,
                                      @"deviceid":dInfo.deviceid,
                                      @"systemVersion":dInfo.systemVersion,
                                      @"appID":dInfo.appID,
                                      @"appVersion":dInfo.appVersion,
        };
        return @{@"status":@"1",@"message":@"OK",@"data":dictAllInfo};
    }
    return @{@"status":@"1",@"message":@"OK",@"data":value};
}

- (void)JSGetNavigationBarHeight {
    [self registerHandler:@"JSGetNavigationBarHeight" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        NSDictionary *result = @{
            @"navBarHeight" : [NSString stringWithFormat:@"%f",[DSCommonMethods naviBarHeight]]
        };
        responseCallback(result);
    }];
}

#pragma mark - 设置APP亮度
- (void)JSSetScreenBrightness {
    static CGFloat brightnessSave = 0;
    if (brightnessSave == 0) {
        brightnessSave = [UIScreen mainScreen].brightness;
    }
    
    [self registerHandler:@"JSSetScreenBrightness" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        NSDictionary *parameters = data;
        // 0表示恢复亮度，1表示高亮
        if ([safeString(parameters[@"status"]) isEqualToString:@"0"]) {
            [UIScreen mainScreen].brightness = brightnessSave;
        }else if([safeString(parameters[@"status"]) isEqualToString:@"1"]){
            [UIScreen mainScreen].brightness = 0.9;
        }
    }];
}


#pragma mark - 跳转系统设置
- (void)JSEntrySysSettings {
    [self registerHandler:@"JSEntrySysSettings" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            if ([[[UIDevice currentDevice] systemVersion] compare:@"10"] < NSOrderedAscending) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                // 10 之后用该方法 会异步执行，并在主队列中调用这个指定的 `completion handler`回调
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }];
}

#pragma mark - 能否打开URL
- (void)JSCanOpenURL {
    [self registerHandler:@"JSCanOpenURL" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        NSDictionary *parameters = data;
        NSString *canOpen = @"NO";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:safeString(parameters[@"url"])]]) {
            canOpen = @"YES";
        }
        
        NSDictionary *result = @{
            @"canOpen" : canOpen,
        };
        responseCallback(result);
    }];
}

- (void)JSOpenURL {
    [self registerHandler:@"JSOpenURL" handler:^(id  _Nonnull data, WVJBResponseCallback  _Nonnull responseCallback) {
        NSDictionary *parameters = data;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:safeString(parameters[@"url"])]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:safeString(parameters[@"url"])]];
        }
    }];
}


@end
