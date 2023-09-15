//
//  Target_AmenAccountKit.h
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_AmenAccountKit : NSObject

#pragma mark - TouchID
/*
 、、、TouchID登录、、、
 NSDictionary *parameters = @{ @"touchIDType" : @"1",
                               @"isSessionTimeoutBack" : @"YES/NO",
                               @"popStyle" : @"present/push, 跳转方式",
                               @"nav" : @"控制器"
 };
 返回: callback (NSDictionary)
 ------------------------------------------------------------------
 |key                    |type                    |
 ------------------------------------------------------------------
 |success                |NSString                |登录是否成功 (0/1)
 ------------------------------------------------------------------
 |error                  |NSString                |错误信息
 ------------------------------------------------------------------

 、、、TouchID设置、、、
 NSDictionary *parameters = @{ @"touchIDType" : @"2",
                             @"nav" : @"控制器",
 };
 */
- (void)Action_TouchIDApp:(nullable NSDictionary *)routerParameters;

#pragma mark - VocalApp
/*
 、、、检查声纹开启状态、、、
 NSDictionary *parameters = @{ @"vocalType" : @"0" };
 返回: callback (NSDictionary)
 ------------------------------------------------------------------
 |key                           |type                    |
 ------------------------------------------------------------------
 |                              |                        |vocalPrintInfoResponse
 |VocalRouterModuleAction       |NSString                |
 |                              |                        |vocalPrintInfoLeave
 ------------------------------------------------------------------
 |response                      |NSDictionary            |接口返回的数据
 ------------------------------------------------------------------
 
 NSDictionary *dic = (NSDictionary *)responseModel.routerData;
 if ([dic[@"VocalRouterModuleAction"] isEqualToString:@"vocalPrintInfoResponse"]) {
     NSDictionary *response = dic[@"response"];
     // do response thing
 } else if ([dic[@"VocalRouterModuleAction"] isEqualToString:@"vocalPrintInfoLeave"]) {
     // do leave thing
 }

 、、、声纹登录、、、
 NSDictionary *parameters = @{ @"vocalType" : @"1",
                               @"isSessionTimeoutBack" : @"YES/NO",
                               @"popStyle" : @"present/push, 跳转方式",
                               @"nav" : @"控制器"
 };
 返回: callback (NSDictionary)
 ------------------------------------------------------------------
 |key                    |type                    |
 ------------------------------------------------------------------
 |success                |NSString                |登录是否成功 (0/1)
 ------------------------------------------------------------------
 |error                  |NSString                |错误信息
 ------------------------------------------------------------------

 、、、声纹设置、、、
 NSDictionary *parameters = @{ @"vocalType" : @"2",
                             @"nav" : @"控制器",
 };
 
 
 、、、已设置过声纹、、、
 NSDictionary *parameters = @{ @"vocalType" : @"3",
                               @"nav" : @"控制器"
 };
 
 */
- (void)Action_VocalApp:(nullable NSDictionary *)routerParameters;


#pragma mark - AppleID
- (void)Action_AppleIDApp:(nullable NSDictionary *)routerParameters;

@end

NS_ASSUME_NONNULL_END
