

#import "NrPushManger.h"
#import "NrAuthorityLog.h"


@implementation NrPushManger

+ (void)requestCurrentUserNotificationStatus:(nullable void(^)(NrPushStatus status))handler {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NrPushStatus status = (NrPushStatus)settings.authorizationStatus;
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@(status) forKey:kNrAuthorityLogGetStatus];
                [NrAuthorityLog authorityLogWithType:NrAuthorityLogPush withSubType:1 withDict:dict withDesc:@"iOS_10以上获取当前推送权限状态"];
                if (handler) {
                    handler(status);
                }
            }];
        }
    } else {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        NrPushStatus status;
        if (settings.types == UIUserNotificationTypeNone) {
            status = NrPushStatusNotDetermined;
        } else {
            status = NrPushStatusAuthorized;
        }
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(status) forKey:kNrAuthorityLogGetStatus];
        [NrAuthorityLog authorityLogWithType:NrAuthorityLogPush withSubType:1 withDict:dict withDesc:@"iOS_10以下获取当前推送权限状态"];
        if (handler) {
            handler(status);
        }
        
    }
}

+ (void)requestAuthorizationWithOptions:(NrPushOptions)options completionHandler:(void (^)(BOOL granted, NSError *__nullable error))completionHandler {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptions)options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@(granted) forKey:kNrAuthorityLogRequestStatus];
                if (error) {
                    [dict setObject:error.localizedDescription forKey:kNrAuthorityLogError];
                }
                [NrAuthorityLog authorityLogWithType:NrAuthorityLogPush withSubType:2 withDict:dict withDesc:@"iOS_10以上申请推送权限"];
                if (completionHandler) {
                    completionHandler(granted,error);
                }
            }];
        }
    } else {
        UIUserNotificationType types = UIUserNotificationTypeNone;
        if (options & NrPushOptionBadge) {
            types |= UIUserNotificationTypeBadge;
        }
        if (options & NrPushOptionSound) {
            types |= UIUserNotificationTypeSound;
        }
        if (options & NrPushOptionAlert) {
            types |= UIUserNotificationTypeAlert;
        }
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        NSError *error = [NSError errorWithDomain:@"iOS_10以下，系统没有返回结果" code:10000 userInfo:nil];
        if (completionHandler) {
            completionHandler(NO,error);
        }
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [NrAuthorityLog authorityLogWithType:NrAuthorityLogPush withSubType:2 withDict:dict withDesc:@"iOS_10以下申请推送权限"];
    }
}



@end
