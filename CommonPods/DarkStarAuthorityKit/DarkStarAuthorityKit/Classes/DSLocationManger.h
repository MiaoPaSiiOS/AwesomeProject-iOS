
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/**
 Privacy - Location Always and When In Use Usage Description
 Privacy - Location Always Usage Description
 Privacy - Location When In Use Usage Description
 */

typedef NS_ENUM(int, DSLocationStatus) {
    // 表明用户尚未选择关于客户端是否可以访问硬件
    DSLocationStatusNotDetermined = 0,
    // 客户端未被授权访问位置。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制
    DSLocationStatusRestricted,
    // 明确拒绝用户访问位置
    DSLocationStatusDenied,
    // 客户端授权一直访问位置权限
    DSLocationStatusAuthorizedAlways API_AVAILABLE(macos(10.12), ios(8.0)),
    // 客户端授权使用时候访问位置权限
    DSLocationStatusAuthorizedWhenInUse API_AVAILABLE(ios(8.0)) API_UNAVAILABLE(macos),
};


typedef void(^DSLocationStatusChange)(DSLocationStatus status);

NS_ASSUME_NONNULL_BEGIN

@interface DSLocationManger : NSObject

/// 定位
@property (nonatomic, strong, readonly) CLLocationManager *locationManger;


+ (instancetype)defaultDSLocationManger;

/// 定位权限状态改变 默认回调用这个block
//@property (nonatomic, copy) DSLocationStatusChange statusChangeBlock;


/**
 系统定位权限

 @return 返回是否开启
 */
+ (BOOL)locationServicesEnabled;

/**
 app 定位权限状态

 @return 返回当前的定位权限
 */
+ (DSLocationStatus)authorizationStatus;



/**
 iOS8 以后需要调用这个方法，获取定位权限
 当+authorizationStatus == DSAuthorizationStatusNotDetermined,调用这个方法
 */
- (void)requestWhenInUseAuthorization;


/**
 iOS8 以后需要调用这个方法，获取定位权限
 当+authorizationStatus == DSAuthorizationStatusNotDetermined,调用这个方法
 */
- (void)requestAlwaysAuthorization;

@end

NS_ASSUME_NONNULL_END
