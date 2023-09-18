
#import "NrMediaManger.h"
#import "NrAuthorityLog.h"


@implementation NrMediaManger


+ (NrMediaStatus)authorizationStatusForMediaType:(AVMediaType)mediaType {
    
    
    NrMediaStatus status = (NrMediaStatus)[AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kNrAuthorityLogGetStatus];
    [dict setObject:mediaType forKey:@"AVMediaType"];
    [NrAuthorityLog authorityLogWithType:NrAuthorityLogMedia withSubType:1 withDict:dict withDesc:@""];
    
    
    return status;
}


+ (void)requestAccessForMediaType:(AVMediaType)mediaType completionHandler:(nullable void (^)(BOOL granted))handler {
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@(granted) forKey:kNrAuthorityLogRequestStatus];
        [dict setObject:mediaType forKey:@"AVMediaType"];
        [NrAuthorityLog authorityLogWithType:NrAuthorityLogMedia withSubType:2 withDict:dict withDesc:@""];
        if (handler) {
            handler(granted);
        }
    }];
}

@end
