

#import "DSLocationManger.h"
#import "DSAuthorityLog.h"


@interface DSLocationManger()


@property (nonatomic, strong, readwrite) CLLocationManager *locationManger;


@end

@implementation DSLocationManger

static DSLocationManger *manger = nil;
+ (instancetype)defaultDSLocationManger {
    if (!manger) {
        manger = [[DSLocationManger alloc] init];
        manger.locationManger = [CLLocationManager new];
//        manger.locationManger.delegate = manger;
    }
    return manger;
}

+ (BOOL)locationServicesEnabled {
    
    BOOL status = [CLLocationManager locationServicesEnabled];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:@"locationServicesEnabled"];
    
    [DSAuthorityLog authorityLogWithType:DSAuthorityLogLocation withSubType:1 withDict:dict withDesc:@"获取当前手机定位权限状态"];
    
    return status;
}


+ (DSLocationStatus)authorizationStatus {
    
    DSLocationStatus status = (DSLocationStatus)[CLLocationManager authorizationStatus];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(status) forKey:kDSAuthorityLogGetStatus];

    [DSAuthorityLog authorityLogWithType:DSAuthorityLogLocation withSubType:1 withDict:dict withDesc:@"获取当前app定位权限状态"];
    
    
    return status;
}



- (void)requestWhenInUseAuthorization {
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [DSAuthorityLog authorityLogWithType:DSAuthorityLogLocation withSubType:2 withDict:dict withDesc:@"申请使用时候定位权限"];
    
    [manger.locationManger requestWhenInUseAuthorization];
}


- (void)requestAlwaysAuthorization {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [DSAuthorityLog authorityLogWithType:DSAuthorityLogLocation withSubType:2 withDict:dict withDesc:@"申请一直定位权限"];
    [manger.locationManger requestAlwaysAuthorization];
}

@end
