
#import "DSMediaManger.h"
#import "DSAuthorityLog.h"


@implementation DSMediaManger


+ (DSMediaStatus)authorizationStatusForMediaType:(AVMediaType)mediaType {
    
    
    DSMediaStatus status = (DSMediaStatus)[AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kDSAuthorityLogGetStatus];
    [dict setObject:mediaType forKey:@"AVMediaType"];
    [DSAuthorityLog authorityLogWithType:DSAuthorityLogMedia withSubType:1 withDict:dict withDesc:@""];
    
    
    return status;
}


+ (void)requestAccessForMediaType:(AVMediaType)mediaType completionHandler:(nullable void (^)(BOOL granted))handler {
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(granted) forKey:kDSAuthorityLogRequestStatus];
        [dict setObject:mediaType forKey:@"AVMediaType"];
        [DSAuthorityLog authorityLogWithType:DSAuthorityLogMedia withSubType:2 withDict:dict withDesc:@""];
        if (handler) {
            handler(granted);
        }
    }];
}

@end
