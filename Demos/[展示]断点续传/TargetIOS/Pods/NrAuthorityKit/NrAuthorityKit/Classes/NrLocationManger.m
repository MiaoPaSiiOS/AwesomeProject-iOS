

#import "NrLocationManger.h"
#import "NrAuthorityLog.h"


@interface NrLocationManger()


@property (nonatomic, strong, readwrite) CLLocationManager *locationManger;


@end

@implementation NrLocationManger

static NrLocationManger *manger = nil;
+ (instancetype)defaultNrLocationManger {
    if (!manger) {
        manger = [[NrLocationManger alloc] init];
        manger.locationManger = [CLLocationManager new];
//        manger.locationManger.delegate = manger;
    }
    return manger;
}

+ (BOOL)locationServicesEnabled {
    
    BOOL status = [CLLocationManager locationServicesEnabled];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:@"locationServicesEnabled"];
    
    [NrAuthorityLog authorityLogWithType:NrAuthorityLogLocation withSubType:1 withDict:dict withDesc:@"获取当前手机定位权限状态"];
    
    return status;
}


+ (NrLocationStatus)authorizationStatus {
    
    NrLocationStatus status = (NrLocationStatus)[CLLocationManager authorizationStatus];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kNrAuthorityLogGetStatus];

    [NrAuthorityLog authorityLogWithType:NrAuthorityLogLocation withSubType:1 withDict:dict withDesc:@"获取当前app定位权限状态"];
    
    
    return status;
}



- (void)requestWhenInUseAuthorization {
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [NrAuthorityLog authorityLogWithType:NrAuthorityLogLocation withSubType:2 withDict:dict withDesc:@"申请使用时候定位权限"];
    
    [manger.locationManger requestWhenInUseAuthorization];
}


- (void)requestAlwaysAuthorization {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [NrAuthorityLog authorityLogWithType:NrAuthorityLogLocation withSubType:2 withDict:dict withDesc:@"申请一直定位权限"];
    [manger.locationManger requestAlwaysAuthorization];
}

@end
