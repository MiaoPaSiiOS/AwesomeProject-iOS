

#import "NrEventManger.h"
#import "NrAuthorityLog.h"


@implementation NrEventManger


+ (NrEventAuthorizationStatus)getEventAuthorizationWithEntityType:(EKEntityType)type {
    NrEventAuthorizationStatus status = (NrEventAuthorizationStatus)[EKEventStore  authorizationStatusForEntityType:type];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kNrAuthorityLogGetStatus];
    [dict setObject:@(type) forKey:@"EKEntityType"];
    NSString * str = @"获取当前备忘录权限状态";
    if (type == EKEntityTypeEvent) {
        str = @"获取当前日历权限状态";
    }
    [NrAuthorityLog authorityLogWithType:NrAuthorityLogEvent withSubType:1 withDict:dict withDesc:str];
    return status;
}

+ (void)requestAccessToEntityType:(EKEntityType)type
                       completion:(nullable void(^)(BOOL granted, NSError * _Nullable error))completion {
    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(granted) forKey:kNrAuthorityLogRequestStatus];
        [dict setObject:@(type) forKey:@"EKEntityType"];
        NSString * str = @"获取备忘录权限";
        if (type == EKEntityTypeEvent) {
            str = @"获取日历权限";
        }
        if (error) {
            [dict setObject:error.localizedDescription forKey:kNrAuthorityLogError];
        }
        [NrAuthorityLog authorityLogWithType:NrAuthorityLogEvent withSubType:2 withDict:dict withDesc:str];
        
        if (completion) {
            completion(granted,error);
        }
    }];
}

@end
