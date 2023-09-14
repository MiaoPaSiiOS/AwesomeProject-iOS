

#import "DSPhotoManger.h"
#import <Photos/PHPhotoLibrary.h>
#import "DSAuthorityLog.h"


@implementation DSPhotoManger


+ (DSPhotoStatus)authorizationStatus {
    
    DSPhotoStatus status = (DSPhotoStatus)[PHPhotoLibrary authorizationStatus];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kDSAuthorityLogGetStatus];
    
    [DSAuthorityLog authorityLogWithType:DSAuthorityLogPhoto withSubType:1 withDict:dict withDesc:@"获取当前相册权限状态"];
    
    
    return status;
}


+ (void)requestAuthorization:(nullable void(^)(DSPhotoStatus status))handler {
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(status) forKey:kDSAuthorityLogRequestStatus];
            [DSAuthorityLog authorityLogWithType:DSAuthorityLogPhoto withSubType:2 withDict:dict withDesc:@"申请相册权限"];
            if (handler) {
                handler((DSPhotoStatus)status);
            }
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(status) forKey:kDSAuthorityLogRequestStatus];
            [DSAuthorityLog authorityLogWithType:DSAuthorityLogPhoto withSubType:2 withDict:dict withDesc:@"申请相册权限"];
            if (handler) {
                handler((DSPhotoStatus)status);
            }
        }];
    }
    
}


@end
