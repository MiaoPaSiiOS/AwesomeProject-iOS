//
//  NrAppUpdateConfig.h
//  IU_UpdateSDK
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateEVersionKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateEModelKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateAppIdKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateAppVersionKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateOsKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateOsVersionKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateHostKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateDeviceIdKey;

FOUNDATION_EXPORT NSString * _Nullable const NrAppUpdateEncryptRsaKey;
@interface NrAppUpdateConfig : NSObject
@property (nonatomic, copy, readonly) NSString *e_version; // RSA秘钥版本号(如果存在e_model则必填)
@property (nonatomic, copy, readonly) NSString *e_model; // 对敏感信息使用RSA加密后的字符串
@property (nonatomic, copy, readonly) NSString *appId; // 渠道号
@property (nonatomic, copy, readonly) NSString *appVersion; // 手机端当前app产品版本号
@property (nonatomic, copy, readonly) NSString *os; // 手机操作系统类型[android/ios, 或者 1/2]
@property (nonatomic, copy, readonly) NSString *osVersion; // 手机操作系统版本号
@property (nonatomic, copy, readonly) NSString *host; // host地址

+ (instancetype)configWithDict:(NSDictionary *)dictionary;

- (instancetype)initWithAppId:(NSString *)appId
                   appVersion:(NSString *)appVersion
                encryptRsaKey:(NSString *)key;

- (instancetype)initWithAppId:(NSString *)appId
                   appVersion:(NSString *)appVersion
                encryptRsaKey:(NSString *)key
                         host:(NSString *)host;

- (instancetype)initWithAppId:(NSString *)appId
                   appVersion:(NSString *)appVersion
                encryptRsaKey:(NSString *)key
                     deviceId:(NSString *)deviceId
                         host:(NSString *)host;

@end

NS_ASSUME_NONNULL_END
