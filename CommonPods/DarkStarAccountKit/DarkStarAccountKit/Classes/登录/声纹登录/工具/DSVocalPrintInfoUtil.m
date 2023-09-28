//
//  DSVocalPrintInfoUtil.m
//  AmenAccountKit
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "DSVocalPrintInfoUtil.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <DarkStarNetWorkKit/DarkStarNetWorkKit.h>
#import "DSUserSession.h"

@implementation DSVocalPrintInfoUtil
+ (void)vocalOpenStatusDes:(VocalStatus)vStatus leave:(LeaveStatus)leave {

    //声纹开关（1打开  0关闭）
    NSString *vocalPrintSwitchStr = [DSCommonMethods safeString:([[NSUserDefaults standardUserDefaults] objectForKey:@"VocalPrintSwitch"])];
    if (![vocalPrintSwitchStr isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"vocalText"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"vocalToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (leave) {
            leave();
        }
        return;
    }
    //实名等级 String N 0为非实名用户，1为强实名用户，2为弱实名用户
    NSString *verifyLevelStr = [[DSUserSession sharedInstance].userinfo objectForKey:@"VerifyLevel"];
    if ([verifyLevelStr isEqualToString:@"1"] || [verifyLevelStr isEqualToString:@"2"]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[DSCommonMethods safeString:([DSUserSession sharedInstance].userid)],@"userId",nil];
        // 查询声纹是否开通
        [[DSNetWorkManager sharedInstance] dataTaskWithUrlPath:@"" requestType:DSNetworkRequestTypeGET header:nil params:dict completionHandler:^(DSNetResponse *response) {
            if (response.success) {
                [[NSUserDefaults standardUserDefaults] setObject:[DSCommonMethods safeString:(response.responseObject[@"vocalToken"])] forKey:@"vocalToken"];
                 [[NSUserDefaults standardUserDefaults] setObject:[DSCommonMethods safeString:(response.responseObject[@"vocalText"])] forKey:@"vocalText"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"vocalText"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"vocalToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            if (vStatus) {
                vStatus(response.responseObject);
            }
            if (leave) {
                leave();
            }
        }];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"vocalText"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"vocalToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (vStatus) {
            vStatus(@{});
        }
        if (leave) {
            leave();
        }
    }
    
}


@end
