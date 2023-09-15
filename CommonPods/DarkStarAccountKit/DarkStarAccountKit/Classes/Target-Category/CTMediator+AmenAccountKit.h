//
//  CTMediator+AmenAccountKit.h
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <CTMediator/CTMediator.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (AmenAccountKit)
/*
 ==============
 TouchID登录
 NSDictionary *parameters = @{ @"touchIDType" : @"1",
                               @"isSessionTimeoutBack" : @"YES/NO",
                               @"popStyle" : @"present/push, 跳转方式",
                               @"nav" : @"控制器"
 };
 其中: responseModel.routerData (NSDictionary)
 success(NSString) : 登录是否成功 (0/1)
 error(NSString)   : 错误信息

 ==============
 TouchID设置
 NSDictionary *parameters = @{ @"touchIDType" : @"2",
                             @"nav" : @"控制器",
 };
 */
- (void)mediator_TouchIDApp:(nullable NSMutableDictionary *)params completion:(IUVoidBlock_id)completion;

/*
 ==============
 检查声纹开启状态, type = 0
 NSDictionary *parameters = @{ @"vocalType" : @"0" };
 vocalPrintInfoResponse(NSString) : 接口返回
 response(NSDictionary)           : 接口返回s数据
 vocalPrintInfoLeave              : 离开时间组

 NSDictionary *dic = (NSDictionary *)responseModel.routerData;
 if ([dic[@"VocalRouterModuleAction"] isEqualToString:@"vocalPrintInfoResponse"]) {
     NSDictionary *response = dic[@"response"];
     // do response thing
 } else if ([dic[@"VocalRouterModuleAction"] isEqualToString:@"vocalPrintInfoLeave"]) {
     // do leave thing
 }

 ==============
 声纹登录
 NSDictionary *parameters = @{ @"vocalType" : @"1",
                               @"isSessionTimeoutBack" : @"YES/NO",
                               @"popStyle" : @"present/push, 跳转方式",
                               @"nav" : @"控制器"
 };
 其中: responseModel.routerData (NSDictionary)
 success(NSString) : 登录是否成功 (0/1)
 error(NSString)   : 错误信息

 ==============
 声纹设置
 NSDictionary *parameters = @{ @"vocalType" : @"2",
                             @"nav" : @"控制器",
                             @"styleInto" : @"模式, 现在统一为 0"
 };
 
 
 ==============
 已设置过声纹
 NSDictionary *parameters = @{ @"vocalType" : @"3",
                               @"nav" : @"控制器"
 };
 */
- (void)mediator_VocalApp:(nullable NSMutableDictionary *)params completion:(IUVoidBlock_id)completion;


/*
 ==============
 AppleID登录
 NSDictionary *parameters = @{
 
 };
 其中: responseModel.routerData (NSDictionary)
 success(BOOL) : 登录是否成功 (0/1)
 error(NSString)   : 错误信息
 params(NSDictionary) : 登录回调
 ==============
 TouchID设置
 NSDictionary *parameters = @{ @"touchIDType" : @"2",
                             @"nav" : @"控制器",
 };
 */
- (void)mediator_AppleIDApp:(nullable NSMutableDictionary *)params completion:(IUVoidBlock_id)completion;

@end

NS_ASSUME_NONNULL_END
