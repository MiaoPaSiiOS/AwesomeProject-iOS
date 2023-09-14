//
//  DSEnvironmentTool.m
//  DarkStarConfiguration
//
//  Created by zhuyuhui on 2023/6/2.
//

#import "DSEnvironmentTool.h"
#import "MJExtension.h"
#import "SIAlertView.h"
#import "DSDBTool.h"
#import "DSAppConfiguration.h"

@implementation DSEnvironmentTool
#pragma mark -- 切换环境
+ (void)switchEnvironment{
    NSData *data = [[DSDBTool shareDatabase] readValueForkey:developer_url];
    DSEnvironment *cacheModel = [DSEnvironment mj_objectWithKeyValues:data];

    NSString *appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString* message = [NSString stringWithFormat:@"重启下清理页面缓存😘\n编译时间：%@\n\n编译:%@(%@)", [self buildTime],appVersion,[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"选择开发环境(请重启app)" andMessage:message];
    for (DSEnvironment *model in [DSAppConfiguration shareConfiguration].environments) {
        SIAlertViewButtonType style = SIAlertViewButtonTypeDefault;
                if ([model.title isEqualToString:cacheModel.title]) {
            style = SIAlertViewButtonTypeDestructive;
        }

        [alertView addButtonWithTitle:model.title type:style handler:^(SIAlertView *alertView) {
            [[DSDBTool shareDatabase] saveValue:model.mj_JSONObject forKey:developer_url];
            [DSAppConfiguration shareConfiguration].environment = model;
            exit(1);
        }];
    }
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
    }];

    [alertView show];
}

+ (NSString*)buildTime
{
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    NSDate* date = [formatter dateFromString:timeStr];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    timeStr = [formater stringFromDate:date];
    return timeStr;
}


@end
