//
//  DSAppleIDLoginManager.m
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "DSAppleIDLoginManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <DarkStarNetWorkKit/DarkStarNetWorkKit.h>
API_AVAILABLE(ios(13.0))
@implementation DSAppleIDLoginManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DSAppleIDLoginManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)signInWithApple API_AVAILABLE(ios(13.0))
{
    //基于用户的Apple ID授权用户，生成用户授权请求的一种机制
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    //授权请求AppleID
    ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
    [request setRequestedScopes:@[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail]];
    //由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    //设置授权控制器通知授权请求的成功与失败的代理
    controller.delegate = self;
    //设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
    controller.presentationContextProvider = self;
    //在控制器初始化期间启动授权流
    [controller performRequests];
}

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        if (self.appleIDLoginBindBlock) {
            [self checkThirdPartyIsBind:credential];
        }
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0))
{
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"你已经取消了本次授权";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    [[DSCommonMethods findTopViewController] ds_showAlertControllerWithTitle:nil message:errorMsg alertClick:^(NSInteger clickNumber) {
        
    }];
}

- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller {
    return [UIApplication sharedApplication].delegate.window;
}

// 判断Apple ID 是否绑定过账户
- (void)checkThirdPartyIsBind:(ASAuthorizationAppleIDCredential *)credential {
    NSDictionary *dic = [[NSDictionary alloc] init];
    NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
    dic = @{ @"thirdPtyType": @"1", @"thirdPtyAuthCodeOrToken": safeString(identityToken) };
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
                                     @"thirdAccountId": safeString(credential.user),
                                     @"thirdAccountEmail": safeString(credential.email),
                                     @"UN": safeString(credential.user)
    }];
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:[DSCommonMethods findTopViewController].view animated:YES];
    [[DSNetWorkManager sharedInstance] dataTaskWithUrlPath:@"" requestType:DSNetworkRequestTypeGET header:nil params:nil completionHandler:^(DSNetResponse *response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:[DSCommonMethods findTopViewController].view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)response;
        if (response.error) {
            NSString *errorCode = [NSString stringWithFormat:@"%ld", (long)response.error.code];
            NSString *errorMsg = [NSString stringWithFormat:@"%@", response.error.localizedDescription];
            [[DSCommonMethods findTopViewController] ds_showAlertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@(%@)",errorMsg,errorCode] alertClick:^(NSInteger clickNumber) {}];

        } else {
            if ([[responseDic objectForKey:@"bindAmen"] isEqualToString:@"true"]) { //Apple ID绑定账户
                [parm setValue:@"1" forKey:@"thirdAccountOptType"];
                [parm setObject:@"AppleID" forKey:@"UT"];
                strongSelf.appleIDLoginBindBlock(credential, YES, parm);
            } else {
                [parm setValue:@"0" forKey:@"thirdAccountOptType"];
                [parm setValue:@"1" forKey:@"thirdAccountType"];
                strongSelf.appleIDLoginBindBlock(credential, NO, parm);
            }
        }
    }];
}

@end
