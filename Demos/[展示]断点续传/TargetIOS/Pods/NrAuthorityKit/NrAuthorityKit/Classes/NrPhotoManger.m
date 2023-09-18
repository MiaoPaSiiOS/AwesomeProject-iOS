

#import "NrPhotoManger.h"
#import <Photos/PHPhotoLibrary.h>
#import "NrAuthorityLog.h"


@implementation NrPhotoManger


+ (NrPhotoStatus)authorizationStatus {
    
    NrPhotoStatus status = (NrPhotoStatus)[PHPhotoLibrary authorizationStatus];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kNrAuthorityLogGetStatus];
    
    [NrAuthorityLog authorityLogWithType:NrAuthorityLogPhoto withSubType:1 withDict:dict withDesc:@"获取当前相册权限状态"];
    
    
    return status;
}


+ (void)requestAuthorization:(nullable void(^)(NrPhotoStatus status))handler {
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(status) forKey:kNrAuthorityLogRequestStatus];
            [NrAuthorityLog authorityLogWithType:NrAuthorityLogPhoto withSubType:2 withDict:dict withDesc:@"申请相册权限"];
            if (handler) {
                handler((NrPhotoStatus)status);
            }
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(status) forKey:kNrAuthorityLogRequestStatus];
            [NrAuthorityLog authorityLogWithType:NrAuthorityLogPhoto withSubType:2 withDict:dict withDesc:@"申请相册权限"];
            if (handler) {
                handler((NrPhotoStatus)status);
            }
        }];
    }
    
}


@end
