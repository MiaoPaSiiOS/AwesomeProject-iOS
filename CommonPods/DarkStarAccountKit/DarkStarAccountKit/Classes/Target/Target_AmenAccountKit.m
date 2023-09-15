//
//  Target_AmenAccountKit.m
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "Target_AmenAccountKit.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>

//TouchID
#import "AMENTouchIDLoginViewController.h"
#import "AMENTouchIDSettingViewController.h"

//声纹
#import "AMENVocalLoginViewController.h"
#import "AMENVocalSetViewController.h"
#import "AMENVocalPrintSecretViewController.h"
#import "AMENVocalPrintInfoUtil.h"

//
#import "AMENAppleIDLoginManager.h"
@implementation Target_AmenAccountKit
#pragma mark - TouchID
- (void)Action_TouchIDApp:(nullable NSDictionary *)routerParameters;
{
    NSString *type = routerParameters[@"touchIDType"];
    IUBoolBlock_id callback = routerParameters[@"callback"];
    if ([type isEqualToString:@"1"]) {
        [self pushTouchIDLoginViewController:routerParameters callback:callback];
    } else if ([type isEqualToString:@"2"]) {
        [self pushTouchIDSettingViewController:routerParameters callback:callback];
    }
}

- (void)pushTouchIDLoginViewController:(NSDictionary *)parameter callback:(nullable IUBoolBlock_id)callback {
    if (isDictEmptyOrNil(parameter)) return;
    AMENTouchIDLoginViewController *vocalLoginVC = [[AMENTouchIDLoginViewController alloc] init];
    vocalLoginVC.touchIDLoginBlock = ^(BOOL success, NSString *error) {
        if (callback) {
            callback(@{
                @"success": safeString(([NSString stringWithFormat:@"%d", success])),
                @"error": safeString(error)
            });
        }
    };
    
    if ([safeString(parameter[@"popStyle"]) isEqualToString:@"push"]) {
        UINavigationController *nvc = [self findNavFromParmer:parameter];
        [nvc pushViewController:vocalLoginVC animated:YES];
    } else if ([safeString(parameter[@"popStyle"]) isEqualToString:@"present"]) {
        UINavigationController *nvc = [self findNavFromParmer:parameter];
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vocalLoginVC];
        naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [nvc presentViewController:naviVC animated:YES completion:nil];
    }
}

- (void)pushTouchIDSettingViewController:(NSDictionary *)parameter callback:(nullable IUBoolBlock_id)callback {
    if (isDictEmptyOrNil(parameter)) return;
    UINavigationController *nvc = [self findNavFromParmer:parameter];
    AMENTouchIDSettingViewController *vc = [[AMENTouchIDSettingViewController alloc] init];
    [nvc pushViewController:vc animated:YES];
}

#pragma mark - VocalApp
- (void)Action_VocalApp:(nullable NSDictionary *)routerParameters;
{
    if (isDictEmptyOrNil(routerParameters)) return;
    NSString *type = routerParameters[@"vocalType"];
    IUBoolBlock_id callback = routerParameters[@"callback"];
    if ([type isEqualToString:@"0"]) {
        [self getVocalPrintInfo:callback];
    } else if ([type isEqualToString:@"1"]) {
        [self pushVocalLoginViewController:routerParameters callback:callback];
    } else if ([type isEqualToString:@"2"]) {
        [self pushVocalPrintSecretViewController:routerParameters callback:callback];
    } else if ([type isEqualToString:@"3"]) {
        UINavigationController *nvc = [self findNavFromParmer:routerParameters];
        AMENVocalSetViewController *vc = [[AMENVocalSetViewController alloc] init];
        [nvc pushViewController:vc animated:YES];
    }
}


- (void)getVocalPrintInfo:(nullable IUBoolBlock_id)callback {
    [AMENVocalPrintInfoUtil vocalOpenStatusDes:^(NSDictionary * _Nullable dict) {
        if (isDictEmptyOrNil(dict)) {
            NSDictionary *callBackDict = @{@"VocalRouterModuleAction" : @"vocalPrintInfoResponse"};
            if (callback) {
                callback(callBackDict);
            }
        } else {
            NSDictionary *callBackDict = @{
                @"VocalRouterModuleAction" : @"vocalPrintInfoResponse",
                @"response": dict
            };
            if (callback) {
                callback(callBackDict);
            }
        }
    } leave:^{
        NSDictionary *callBackDict = @{@"VocalRouterModuleAction" : @"vocalPrintInfoLeave"};
        if (callback) {
            callback(callBackDict);
        }
    }];
}


- (void)pushVocalLoginViewController:(NSDictionary *)parameter callback:(nullable IUBoolBlock_id)callback {
    if (isDictEmptyOrNil(parameter)) return;
    AMENVocalLoginViewController *vocalLoginVC = [[AMENVocalLoginViewController alloc] init];
    vocalLoginVC.vocalLoginBlock = ^(BOOL success, NSString *error) {
        if (callback) {
            callback(@{
                @"success": safeString(([NSString stringWithFormat:@"%d", success])),
                @"error": safeString(error)
            });
        }
    };
    
    if ([safeString(parameter[@"popStyle"]) isEqualToString:@"push"]) {
        UINavigationController *nvc = [self findNavFromParmer:parameter];
        [nvc pushViewController:vocalLoginVC animated:YES];
    } else if ([safeString(parameter[@"popStyle"]) isEqualToString:@"present"]) {
        UINavigationController *nvc = [self findNavFromParmer:parameter];
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vocalLoginVC];
        naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [nvc presentViewController:naviVC animated:YES completion:nil];
    }
}

- (void)pushVocalPrintSecretViewController:(NSDictionary *)parameter callback:(nullable IUBoolBlock_id)callback {
    if (isDictEmptyOrNil(parameter)) return;
    UINavigationController *nvc = [self findNavFromParmer:parameter];
    AMENVocalPrintSecretViewController *vc = [[AMENVocalPrintSecretViewController alloc] init];
    [nvc pushViewController:vc animated:YES];
}


#pragma mark - AppleID
- (void)Action_AppleIDApp:(nullable NSDictionary *)routerParameters;
{
    IUBoolBlock_id callback = routerParameters[@"callback"];
    if (@available(iOS 13.0, *)) {
        [[AMENAppleIDLoginManager sharedInstance] setAppleIDLoginBindBlock:^(ASAuthorizationAppleIDCredential *_Nonnull credential, BOOL isBind, NSDictionary *_Nonnull param) {
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setDictionary:param];
            if (callback) {
                callback(@{
                    @"success": @(YES),
                    @"params":paramDic
                });
            }
        }];
        [[AMENAppleIDLoginManager sharedInstance] signInWithApple];
    } else {
        if (callback) {
            callback(@{
                @"success": @(NO),
                @"error": @"系统版本最低iOS13！"
            });
        }
    }
}



#pragma mark - private
- (UINavigationController *)findNavFromParmer:(NSDictionary *)routerParameters {
    if (isDictEmptyOrNil(routerParameters)) return nil;
    if ([routerParameters objectForKey:@"nav"] && [[routerParameters objectForKey:@"nav"] isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)[routerParameters objectForKey:@"nav"];;
    } else {
        return self.ds_topViewController.navigationController;
    }
}

@end
